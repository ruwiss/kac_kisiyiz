import { Router } from "express";
import { ExpressHelper } from "../functions/expressHelper";
import { Connector } from "../connector";
import jwt, { Secret } from "jsonwebtoken";
import path from "path";
import { createTransport } from "nodemailer";
import { RowDataPacket, ResultSetHeader } from "mysql2";

const helper = new ExpressHelper();

function tokenRouter(router: Router, root: Connector): Router {
  router.post("/token", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("mainToken")) return helper.sendErrorMissingData(res);

    jwt.verify(
      args.mainToken,
      req.app.get("api_secret_key") as Secret,
      (error: any, decoded: any) => {
        if (error) return res.status(401).send(error.message);
        if (!decoded.isAuth)
          return res.status(401).send({ msg: "Token Error" });
        decoded.isAuth = false;
        res.json({ token: helper.createUserToken(decoded, req, false) });
      }
    );
  });

  router.post("/auth", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!helper.listContainsList(keys, ["mail", "password"]))
      return helper.sendErrorMissingData(res);

    const sql = `SELECT id, mail, name, password FROM users WHERE mail = '${args.mail}'`;
    root.con.getConnection((_, con) => {
      con.query<RowDataPacket[]>(sql, (err, result) => {
        if (err) {
          con.release();
          return helper.sendError(err, res);
        }

        if (result[0]) {
          con.release();
          return res
            .status(422)
            .json({ msg: "Zaten böyle bir kullanıcı kayıtlı." });
        }

        // Kullanıcı kaydı oluşturma
        const insertSql = `INSERT INTO users (mail, password, name) VALUES (?, ?, ?)`;
        const values = [args.mail, args.password, args.name];
        con.query<ResultSetHeader>(insertSql, values, (err, fields) => {
          if (err) {
            con.release();
            res.status(502).json({ msg: err.message });
          }
          con.release();
          return res.json({
            msg: "Kayıt işlemi başarılı.",
            token: helper.createUserToken(
              {
                id: fields.insertId,
                mail: args.mail,
                password: args.password,
                name: args.name,
              },
              req
            ),
          });
        });
      });
    });
  });

  router.get("/auth", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!helper.listContainsList(keys, ["mail", "password"]))
      return helper.sendErrorMissingData(res);

    // Kullanıcı bilgi sorgulama
    const sql = `SELECT u.*, COUNT(v.id) as voteCount FROM users u LEFT JOIN voted v ON u.id = v.userId WHERE u.mail = ? AND u.password = ?`;
    const values = [args.mail, args.password];
    root.con.getConnection((_, con) => {
      con.query<RowDataPacket[]>(sql, values, (err, result) => {
        if (err) {
          con.release();
          return helper.sendError(err, res);
        }
        if (result[0] && result[0].id != null) {
          con.release();
          return res.json({
            msg: "Giriş Başarılı.",
            user: result[0],
            token: helper.createUserToken(result[0], req),
          });
        }
        con.release();
        return res.status(401).json({ msg: "Yanlış bilgi verdiniz." });
      });
    });
  });

  router.get("/privacyPolicy", (_, res) => {
    res.sendFile(path.join(__dirname + "/docs/privacyPolicy.html"));
  });

  router.post("/forgotPassword", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("mail")) return helper.sendErrorMissingData(res);

    let code = helper.randomNumber(10000, 99999);

    const transporter = createTransport({
      host: process.env.SMTP_HOST,
      port: parseInt(process.env.SMTP_PORT!),
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASSWORD,
      },
    });
    const mailOptions = {
      from: process.env.SMTP_USER,
      to: args.mail,
      subject: `Şifre sıfırlama isteği`,
      text: `Şifreni unuttuğunu gördüm. ${code} kodunu kullanarak yeni şifre oluşturabilirsin.`,
    };

    transporter.sendMail(mailOptions, function (error) {
      if (error) {
        res.status(401).json({ msg: error.message });
      } else {
        root.con.getConnection((_, con) => {
          con.query("DELETE FROM resetpassword WHERE mail = ?", [args.mail]);
          con.query(
            "INSERT INTO resetpassword (mail, code) VALUES (?, ?)",
            [args.mail, code],
            (err) => {
              if (err) {
                con.release();
                return helper.sendError(err, res);
              }
              con.release();
              res.json({ msg: "Mail adresinize kod gönderildi." });
            }
          );
        });
      }
    });
  });

  router.post("/verifyCode", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["mail", "code"];
    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM resetpassword WHERE mail=?`;
    root.con.getConnection((_, con) => {
      con.query<RowDataPacket[]>(sql, [args.mail], (err, result) => {
        if (err) {
          con.release();
          return helper.sendError(err, res);
        }
        if (!result[0]) {
          con.release();
          return res
            .status(401)
            .json({ msg: "Bir sorun oluştu. Biraz sonra tekrar deneyin." });
        }

        const data = result[0];

        const mysqlDate = new Date(data.dateTime);
        const currentDate = new Date();
        if (!helper.validationForResetPassword(mysqlDate, currentDate)) {
          return res
            .status(401)
            .json({ msg: "Sıfırlama bağlantınızın süresi dolmuş." });
        }
        if (args.code == data.code && args.mail == data.mail) {
          return res.json({ msg: "Kod onaylandı." });
        } else {
          return res.status(401).json({ msg: "Hatalı kod girdiniz." });
        }
      });
    });
  });

  router.post("/resetPassword", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["code", "password"];
    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM resetpassword WHERE code=?`;
    root.con.getConnection((_, con) => {
      con.query<RowDataPacket[]>(sql, [args.code], (err, result) => {
        if (err) {
          con.release();
          return helper.sendError(err, res);
        }

        con.query("DELETE FROM resetpassword WHERE code = ?", [args.code]);

        const sql = `UPDATE users SET password = ? WHERE mail = ?`;
        con.query(sql, [args.password, result[0].mail], (err) => {
          if (err) {
            con.release();
            return helper.sendError(err, res);
          }
          con.release();
          return res.json({
            msg: "Şifreniz değiştirildi. Artık giriş yapabilirsiniz.",
          });
        });
      });
    });
  });

  return router;
}

export default tokenRouter;
