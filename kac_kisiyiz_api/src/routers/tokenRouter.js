"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const expressHelper_1 = require("../functions/expressHelper");
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const path_1 = __importDefault(require("path"));
const nodemailer_1 = require("nodemailer");
const helper = new expressHelper_1.ExpressHelper();
function tokenRouter(router, root) {
    router.post("/token", (req, res) => {
        const [args, keys] = helper.getArgsByMethod(req);
        if (!keys.includes("mainToken"))
            return helper.sendErrorMissingData(res);
        jsonwebtoken_1.default.verify(args.mainToken, req.app.get("api_secret_key"), (error, decoded) => {
            if (error)
                return res.status(401).send(error.message);
            if (!decoded.isAuth)
                return res.status(401).send({ msg: "Token Error" });
            decoded.isAuth = false;
            res.json({ token: helper.createUserToken(decoded, req, false) });
        });
    });
    router.post("/auth", (req, res) => {
        const [args, keys] = helper.getArgsByMethod(req);
        if (!helper.listContainsList(keys, ["mail", "password"]))
            return helper.sendErrorMissingData(res);
        const sql = `SELECT id, mail, name, password FROM users WHERE mail = '${args.mail}'`;
        root.con.query(sql, (err, result) => {
            if (err) {
                return helper.sendError(err, res);
            }
            if (result[0]) {
                return res
                    .status(422)
                    .json({ msg: "Zaten böyle bir kullanıcı kayıtlı." });
            }
            // Kullanıcı kaydı oluşturma
            const insertSql = `INSERT INTO users (mail, password, name, onesignalId) VALUES (?, ?, ?, ?)`;
            const values = [args.mail, args.password, args.name, args.onesignalId];
            root.con.query(insertSql, values, (err, fields) => {
                if (err)
                    return helper.sendError(err, res);
                return res.json({
                    msg: "Kayıt işlemi başarılı.",
                    token: helper.createUserToken({
                        id: fields.insertId,
                        mail: args.mail,
                        password: args.password,
                        name: args.name,
                    }, req),
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
        root.con.query(sql, values, (err, result) => {
            if (err) {
                return helper.sendError(err, res);
            }
            if (result[0] && result[0].id != null) {
                return res.json({
                    msg: "Giriş Başarılı.",
                    user: result[0],
                    token: helper.createUserToken(result[0], req),
                });
            }
            return res.status(401).json({ msg: "Yanlış bilgi verdiniz." });
        });
    });
    router.get("/privacyPolicy", (_, res) => {
        res.sendFile(path_1.default.join(__dirname + "/docs/privacyPolicy.html"));
    });
    router.get("/deleteAccount", (_, res) => {
        res.sendFile(path_1.default.join(__dirname + "/docs/deleteAccount.html"));
    });
    router.post("/forgotPassword", (req, res) => {
        const [args, keys] = helper.getArgsByMethod(req);
        if (!keys.includes("mail"))
            return helper.sendErrorMissingData(res);
        let code = helper.randomNumber(10000, 99999);
        const transporter = (0, nodemailer_1.createTransport)({
            host: process.env.SMTP_HOST,
            port: parseInt(process.env.SMTP_PORT),
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
            }
            else {
                root.con.query("DELETE FROM resetpassword WHERE mail = ?", [args.mail]);
                root.con.query("INSERT INTO resetpassword (mail, code) VALUES (?, ?)", [args.mail, code], (err) => {
                    if (err) {
                        return helper.sendError(err, res);
                    }
                    res.json({ msg: "Mail adresinize kod gönderildi." });
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
        root.con.query(sql, [args.mail], (err, result) => {
            if (err) {
                return helper.sendError(err, res);
            }
            if (!result[0]) {
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
            }
            else {
                return res.status(401).json({ msg: "Hatalı kod girdiniz." });
            }
        });
    });
    router.post("/resetPassword", (req, res) => {
        const [args, keys] = helper.getArgsByMethod(req);
        const requirements = ["code", "password"];
        if (!helper.listContainsList(keys, requirements))
            return helper.sendErrorMissingData(res);
        const sql = `SELECT * FROM resetpassword WHERE code=?`;
        root.con.query(sql, [args.code], (err, result) => {
            if (err) {
                return helper.sendError(err, res);
            }
            root.con.query("DELETE FROM resetpassword WHERE code = ?", [args.code]);
            const sql = `UPDATE users SET password = ? WHERE mail = ?`;
            root.con.query(sql, [args.password, result[0].mail], (err) => {
                if (err)
                    return helper.sendError(err, res);
                return res.json({
                    msg: "Şifreniz değiştirildi. Artık giriş yapabilirsiniz.",
                });
            });
        });
    });
    return router;
}
exports.default = tokenRouter;
