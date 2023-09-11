import { Request, Response } from "express";
import { Connector } from "./connector";
import mysql from "mysql";

const root = new Connector();
const app = root.app;

const debug: boolean = true;

const sendError = (err: mysql.MysqlError, res: Response) =>
  res.status(500).send({
    code: err.errno,
    msg: debug ? `HATA: ${err.message}` : "Bir sorun oluştu.",
  });

const sendErrorMissingData = (res: Response) =>
  res.status(400).send({ msg: "Yanlış istek." });

const getArgsByMethod = (req: Request): [any, any[]] => {
  const args = req.method == "GET" ? req.query : req.body;
  const keys = Object.keys(args);
  return [args, keys];
};

const listContainsList = (list: any[], items: any[]): boolean => {
  let contains: boolean = true;
  for (let i = 0; i < 0; i++) if (!list.includes(items[i])) contains = false;
  return contains;
};

//  ---------------------- ALL ----------------------  //

app.all("/auth", (req, res) => {
  const [args, keys] = getArgsByMethod(req);

  if (!listContainsList(keys, ["mail", "password"]))
    return sendErrorMissingData(res);

  if (req.method === "POST") {
    if (!keys.includes("name")) return sendErrorMissingData(res);

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
      const insertSql = `INSERT INTO users (mail, password, name) VALUES (?, ?, ?)`;
      const values = [args.mail, args.password, args.name];
      root.con.query(insertSql, values, (err) => {
        if (err) res.status(502).json({ msg: err.message });
        return res.json({ msg: "Kayıt işlemi başarılı." });
      });
    });
  } else if (req.method === "GET") {
    // Kullanıcı bilgi sorgulama
    const sql = `SELECT id, mail, name, password FROM users WHERE mail = ? AND password = ?`;
    const values = [args.mail, args.password];
    root.con.query(sql, values, (err, result) => {
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

//  -------------------- GETTER --------------------  //

app.get("/settings", (req, res) => {
  const [args, keys] = getArgsByMethod(req);

  const sql = keys.includes("name")
    ? `SELECT * FROM settings WHERE name = '${args.name}'`
    : `SELECT * FROM settings`;
  root.con.query(sql, (err, result) => {
    if (err) return sendError(err, res);
    res.send(result);
  });
});

const getUserValues = (
  res: Response,
  mail: string,
  password: string,
  callback: (user: any) => void
) => {
  const sql = `SELECT * FROM users WHERE mail = ? AND password = ?`;
  const values = [mail, password];
  root.con.query(sql, values, (_, result) => {
    if (result[0]) callback(result[0]);
    else
      res
        .status(400)
        .send({ msg: "Kullanıcı bilgilerini alırken bir sorun oluştu." });
  });
};

app.get("/user", (req, res) => {
  const [args, keys] = getArgsByMethod(req);

  if (!listContainsList(keys, ["mail", "password"]))
    return sendErrorMissingData(res);

  getUserValues(res, args.mail, args.password, (user) => res.send(user));
});

app.get("/bank", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  if (!listContainsList(keys, ["mail", "password"]))
    return sendErrorMissingData(res);

  getUserValues(res, args.mail, args.password, (user) => {
    const sql = `SELECT * FROM bank WHERE userId = ?`;
    root.con.query(sql, [user.id], (err, result) => {
      if (result[0]) res.send(result[0]);
    });
  });
});

app.get("/surveyData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  if (!keys.includes("id")) return sendErrorMissingData(res);

  const sql = `SELECT * FROM surveys WHERE id = ?`;
  root.con.query(sql, [args.id], (err, result) => {
    if (err) return sendError(err, res);
    res.send(result[0]);
  });
});

app.get("/categoryData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  if (!keys.includes("id")) return sendErrorMissingData(res);

  const sql = `SELECT * FROM categories WHERE id = ?`;
  root.con.query(sql, [args.id], (err, result) => {
    if (err) return sendError(err, res);
    res.send(result[0]);
  });
});

app.get("/rewardedData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  if (!keys.includes("id")) return sendErrorMissingData(res);

  const sql = `SELECT * FROM rewarded WHERE id = ?`;
  root.con.query(sql, [args.id], (err, result) => {
    if (err) return sendError(err, res);
    res.send(result[0]);
  });
});

//  -------------------- SETTER --------------------  //

app.post("/settings", (req, res) => {
  const [args] = getArgsByMethod(req);

  const sql = `INSERT INTO settings (name, attr) VALUES (?, ?)`;
  const values = [args.name, args.attr];

  root.con.query(sql, values, (err) => {
    if (err) return sendError(err, res);
    res.send({ msg: "Ayarlar kaydedildi." });
  });
});

app.post("/bank", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  const requirements = ["mail", "password", "nameSurname", "bankName", "iban"];

  if (!listContainsList(keys, requirements)) return sendErrorMissingData(res);

  getUserValues(res, args.mail, args.password, (user) => {
    const insertSql = `INSERT INTO bank (userId, nameSurname, bankName, iban) VALUES (?, ?, ?, ?)`;
    const insertValues = [user.id, args.nameSurname, args.bankName, args.iban];

    root.con.query(insertSql, insertValues, (err) => {
      if (err) return sendError(err, res);
      res.send({ msg: "Banka hesabı kaydedildi." });
    });
  });
});

app.post("/surveyData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  const requirements = [
    "categoryId",
    "userId",
    "title",
    "content",
    "image",
    "adLink",
    "isRewarded",
  ];

  if (!listContainsList(keys, requirements)) return sendErrorMissingData(res);

  const sql = `INSERT INTO surveys (categoryId, userId, title, content, image, ch1, ch2, adLink, isRewarded, isPending) VALUES (?,?,?,?,?,?,?,?,?)`;
  const values = [
    args.categoryId,
    args.userId,
    args.title,
    args.content,
    args.image,
    0,
    0,
    args.adLink,
    args.isRewarded ?? false,
    false,
  ];

  root.con.query(sql, values, (err, result) => {
    if (err) return sendError(err, res);
    res.send({ msg: "Anket başarıyla eklendi." });
  });
});

app.post("/categoryData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  const requirements = ["name", "icon"];

  if (!listContainsList(keys, requirements)) return sendErrorMissingData(res);

  const sql = `INSERT INTO categories (name, icon) VALUES ('${args.name}', '${args.icon}')`;
  root.con.query(sql, (err, result) => {
    if (err) return sendError(err, res);
    res.send({ msg: `${args.name} kategorisi eklendi.` });
  });
});

app.post("/rewardedData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  const requirements = ["surveyId", "reward"];
  if (!listContainsList(keys, requirements)) return sendErrorMissingData(res);

  const sql = `INSERT INTO rewarded (surveyId, reward) VALUES ('${args.surveyId}', '${args.reward}')`;
  root.con.query(sql, (err) => {
    if (err) return sendError(err, res);
    res.send({ msg: `Ödüllü anket ${args.reward}₺ olarak eklendi.` });
  });
});

//  ----------------- PUT / PATCH -----------------  //
app.patch("/settings", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  console.log(keys);
  if (!listContainsList(keys, ["name", "attr"]))
    return sendErrorMissingData(res);

  const sql = `UPDATE settings SET attr = '${args.attr}' WHERE name = '${args.name}'`;
  root.con.query(sql, (err) => {
    if (err) return sendError(err, res);
    res.send({ msg: `${args.name} Başarıyla güncellendi.` });
  });
});

app.patch("/categoryData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  const requirements = ["id", "name", "icon"];
  if (!listContainsList(keys, requirements)) return sendErrorMissingData(res);

  const sql = `UPDATE categories SET name = '${args.name}', icon='${args.icon}' WHERE id = '${args.id}'`;
  root.con.query(sql, (err, result) => {
    if (err) return sendError(err, res);
    res.send({
      msg: `id(${args.id}) ${args.name} olarak başarıyla güncellendi`,
    });
  });
});

//  -------------------- DELETE --------------------  //
app.delete("/settings", (req, res) => {
  const [args, keys] = getArgsByMethod(req);

  if (!keys.includes("name")) return sendErrorMissingData(res);

  const sql = `DELETE FROM settings WHERE name = '${args.name}'`;
  root.con.query(sql, (err) => {
    if (err) sendError(err, res);
    res.send({ msg: `${args.name} silindi.` });
  });
});

app.delete("/rewardedData", (req, res) => {
  const [args, keys] = getArgsByMethod(req);
  if (!keys.includes("id")) return sendErrorMissingData(res);

  const sql = `DELETE FROM rewarded WHERE id='${args.id}'`;
  root.con.query(sql, (err) => {
    if (err) return sendError(err, res);
    res.send({ msg: `Ödül kaldırıldı.` });
  });
});
