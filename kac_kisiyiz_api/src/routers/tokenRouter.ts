import { Router } from "express";
import { ExpressHelper } from "../functions/expressHelper";
import { Connector } from "../connector";
import jwt, { Secret } from "jsonwebtoken";

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
    root.con.query(sql, (err, result) => {
      if (err) return helper.sendError(err, res);

      if (result[0]) {
        return res
          .status(422)
          .json({ msg: "Zaten böyle bir kullanıcı kayıtlı." });
      }

      // Kullanıcı kaydı oluşturma
      const insertSql = `INSERT INTO users (mail, password, name) VALUES (?, ?, ?)`;
      const values = [args.mail, args.password, args.name];
      root.con.query(insertSql, values, (err, fields) => {
        if (err) res.status(502).json({ msg: err.message });
        return res.json({
          msg: "Kayıt işlemi başarılı.",
          name: args.name,
          token: helper.createUserToken(
            {
              id: fields.insertId,
              mail: args.mail,
              password: args.password,
            },
            req
          ),
        });
      });
    });
  });

  router.get("/auth", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!helper.listContainsList(keys, ["mail", "password"]))
      return helper.sendErrorMissingData(res);

    // Kullanıcı bilgi sorgulama
    const sql = `SELECT id, mail, name, password FROM users WHERE mail = ? AND password = ?`;
    const values = [args.mail, args.password];
    root.con.query(sql, values, (err, result) => {
      if (err) return helper.sendError(err, res);
      if (result[0]) {
        return res.json({
          msg: "Giriş Başarılı.",
          name: result[0].name,
          token: helper.createUserToken(result[0], req),
        });
      }
      return res.status(401).json({ msg: "Yanlış bilgi verdiniz." });
    });
  });

  return router;
}

export default tokenRouter;
