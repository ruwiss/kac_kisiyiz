import { Connector } from "./connector";

const root = new Connector();
const app = root.app;

const isEmpty = (obj: any): boolean => Object.keys(obj).length === 0;

app.all("/auth", (req, res) => {
  const args = req.query;
  const argKeys: any[] = Object.keys(args);

  if (
    isEmpty(args) ||
    !argKeys.includes("mail") ||
    !argKeys.includes("password")
  )
    return res.status(400).json({ msg: "Yanlış İstek" });

  if (req.method === "POST") {
    if (!argKeys.includes("name"))
      return res.status(400).json({ msg: "Yanlış İstek" });

    // Kullanıcı kaydı sorgulama
    const sql = `SELECT id, mail, name, password FROM users WHERE mail = '${args.mail}'`;
    root.con.query(sql, (err, result) => {
      if (err)
        return res
          .status(502)
          .json({ msg: "Bir sorun oluştu", error: err.message });

      if (result[0]) {
        return res
          .status(422)
          .json({ msg: "Zaten böyle bir kullanıcı kayıtlı." });
      }

      // Kullanıcı kaydı oluşturma
      const insertSql = `INSERT INTO users (mail, password, name) VALUES ('${args.mail}', '${args.password}', '${args.name}')`;
      root.con.query(insertSql, (err) => {
        if (err) res.status(502).json({ msg: err.message });
        return res.json({ msg: "Kayıt işlemi başarılı." });
      });
    });
  } else if (req.method === "GET") {
    // Kullanıcı bilgi sorgulama
    const sql = `SELECT id, mail, name, password FROM users WHERE mail = '${args.mail}' AND password = '${args.password}'`;
    root.con.query(sql, (err, result) => {
      if (err)
        return res
          .status(502)
          .json({ msg: "Bir sorun oluştu", error: err.message });
      if (result[0]) {
        return res.json({ msg: "Giriş Başarılı." });
      }
      return res.status(401).json({ msg: "Yanlış bilgi verdiniz." });
    });
  }
});
