import { Response, Router } from "express";
import { ExpressHelper } from "../functions/expressHelper";
import { Connector } from "../connector";
import dotenv from "dotenv";

function routes(router: Router, root: Connector): Router {
  const helper = new ExpressHelper();

  //  -------------------- GETTER --------------------  //

  router.get("/settings", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);

    const sql = keys.includes("name")
      ? `SELECT * FROM settings WHERE name = '${args.name}'`
      : `SELECT * FROM settings`;
    root.con.query(sql, (err, result) => {
      if (err) return helper.sendError(err, res);
      res.send(result);
    });
  });

  router.get("/bank", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!helper.listContainsList(keys, ["mail", "password"]))
      return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM bank WHERE userId = ?`;
    root.con.query(sql, [req.body.user.id], (err, result) => {
      if (err) helper.sendError(err, res);
      if (result[0]) res.send(result[0]);
    });
  });

  router.get("/surveyData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM surveys WHERE id = ?`;
    root.con.query(sql, [args.id], (err, result) => {
      if (err) return helper.sendError(err, res);
      res.send(result[0]);
    });
  });

  router.get("/surveys", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    let sql: string;
    let sqlArgs = [];

    const userId = req.body.user.id;

    function getLimit(): number {
      let envLimit = parseInt(process.env.SURVEY_LIMIT as string);
      const sql = `SELECT count FROM dailyvoted WHERE userId = ${userId}`;
      root.con.query(sql, (err, result) => {
        if (err) return helper.sendError(err, res);
        if (result[0]) {
          envLimit = envLimit - result[0].count;
        }
      });
      return envLimit;
    }

    if (keys.includes("voted")) {
      sql = `SELECT s.id, s.categoryId, c.name AS category, u.name AS userName, s.userId, s.title, s.image, s.ch1, s.ch2
      FROM surveys s
      LEFT JOIN categories c ON s.categoryId = c.id
      LEFT JOIN users u ON s.userId = u.id
      INNER JOIN voted v ON s.id = v.surveyId AND v.userId = ?
      WHERE s.content IS NOT NULL
      ORDER BY s.id DESC
      LIMIT ${process.env.SURVEY_LIMIT};`;
      sqlArgs = [userId];
    } else if (keys.includes("categoryId")) {
      const envLimit = getLimit();
      if (envLimit < 1) return res.send([]);
      sql = `SELECT s.*,  c.name AS category, u.name AS userName
      FROM surveys s
      LEFT JOIN voted v ON s.id = v.surveyId AND v.userId = ?
      LEFT JOIN categories c ON s.categoryId = c.id
      LEFT JOIN users u ON s.userId = u.id
      WHERE v.id IS NULL AND s.isPending = 0 AND s.categoryId = ?
      ORDER BY s.id DESC
      LIMIT ${envLimit};`;
      sqlArgs = [userId, args.categoryId];
    } else {
      const envLimit = getLimit();
      if (envLimit < 1) return res.send([]);
      sql = `SELECT s.*,  c.name AS category, u.name AS userName
      FROM surveys s
      LEFT JOIN voted v ON s.id = v.surveyId AND v.userId = ?
      LEFT JOIN categories c ON s.categoryId = c.id
      LEFT JOIN users u ON s.userId = u.id
      WHERE v.id IS NULL AND s.isPending = 0
      ORDER BY s.id DESC
      LIMIT ${envLimit};`;
      sqlArgs = [userId];
    }
    root.con.query(sql, sqlArgs, (err, result) => {
      if (err) return helper.sendError(err, res);
      res.json(result);
    });
  });

  router.get("/categories", (req, res) => {
    const sql = `SELECT * FROM categories`;
    root.con.query(sql, (err, result) => {
      if (err) return helper.sendError(err, res);
      res.send(result);
    });
  });

  router.get("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM categories WHERE id = ?`;
    root.con.query(sql, [args.id], (err, result) => {
      if (err) return helper.sendError(err, res);
      res.send(result[0]);
    });
  });

  router.get("/rewardedData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM rewarded WHERE id = ?`;
    root.con.query(sql, [args.id], (err, result) => {
      if (err) return helper.sendError(err, res);
      res.send(result[0]);
    });
  });

  //  -------------------- SETTER --------------------  //

  router.post("/settings", (req, res) => {
    const [args] = helper.getArgsByMethod(req);

    const sql = `INSERT INTO settings (name, attr) VALUES (?, ?)`;
    const values = [args.name, args.attr];

    root.con.query(sql, values, (err) => {
      if (err) return helper.sendError(err, res);
      res.send({ msg: "Ayarlar kaydedildi." });
    });
  });

  router.post("/bank", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = [
      "mail",
      "password",
      "nameSurname",
      "bankName",
      "iban",
    ];

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const insertSql = `INSERT INTO bank (userId, nameSurname, bankName, iban) VALUES (?, ?, ?, ?)`;
    const insertValues = [
      req.body.user.id,
      args.nameSurname,
      args.bankName,
      args.iban,
    ];

    root.con.query(insertSql, insertValues, (err) => {
      if (err) return helper.sendError(err, res);
      res.send({ msg: "Banka hesabı kaydedildi." });
    });
  });

  router.post("/surveyData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = [
      "categoryId",
      "userId",
      "title",
      "content",
      "image",
      "adLink",
      "isRewarded",
    ];

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

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
      if (err) return helper.sendError(err, res);
      res.send({ msg: "Anket başarıyla eklendi." });
    });
  });

  router.post("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["name", "icon"];

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `INSERT INTO categories (name, icon) VALUES ('${args.name}', '${args.icon}')`;
    root.con.query(sql, (err, result) => {
      if (err) return helper.sendError(err, res);
      res.send({ msg: `${args.name} kategorisi eklendi.` });
    });
  });

  router.post("/rewardedData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["surveyId", "reward"];
    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `INSERT INTO rewarded (surveyId, reward) VALUES ('${args.surveyId}', '${args.reward}')`;
    root.con.query(sql, (err) => {
      if (err) return helper.sendError(err, res);
      res.send({ msg: `Ödüllü anket ${args.reward}₺ olarak eklendi.` });
    });
  });

  //  ----------------- PUT / PATCH -----------------  //
  router.patch("/settings", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!helper.listContainsList(keys, ["name", "attr"]))
      return helper.sendErrorMissingData(res);

    const sql = `UPDATE settings SET attr = '${args.attr}' WHERE name = '${args.name}'`;
    root.con.query(sql, (err) => {
      if (err) return helper.sendError(err, res);
      res.send({ msg: `${args.name} Başarıyla güncellendi.` });
    });
  });

  router.patch("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["id", "name", "icon"];
    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `UPDATE categories SET name = '${args.name}', icon='${args.icon}' WHERE id = '${args.id}'`;
    root.con.query(sql, (err) => {
      if (err) return helper.sendError(err, res);
      res.send({
        msg: `id(${args.id}) ${args.name} olarak başarıyla güncellendi`,
      });
    });
  });

  router.patch("/surveyData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["id", "vote"];

    if (!helper.listContainsList(keys, requirements) || args.vote.length < 3)
      return helper.sendErrorMissingData(res);

    const userId = req.body.user.id;

    // Anketlerin katılım sayısında artırma işlemi
    const sql = `UPDATE surveys SET ${args.vote} = ${args.vote} + 1 WHERE id = ?`;
    const values = [args.id];

    root.con.query(sql, values, (err) => {
      if (err) return helper.sendError(err, res);

      // Kullanıcı oylarına, kullanıcıyı ekleme işlemi
      const sql = `INSERT INTO voted (surveyId, userId, vote) VALUES (?, ?, ?)`;
      const values = [args.id, userId, args.vote];
      root.con.query(sql, values, (err) => {
        if (err) return helper.sendError(err, res);

        // Kullanıcının günlük yaptığı oylama sayısında arttırma işlemi
        const sql = `SELECT id FROM dailyvoted WHERE userId = ${userId}`;
        root.con.query(sql, (err, result) => {
          if (err) return helper.sendError(err, res);
          let dailyVotedSql: string;
          if (result[0]) {
            // Patch
            const mysqlDate = new Date(result[0].dateTime);
            const currentDate = new Date();
            const isSameDay = helper.areDatesOnSameDay(mysqlDate, currentDate);
            console.log("isSameDay: ", isSameDay);
            if (isSameDay) {
              dailyVotedSql = `UPDATE dailyvoted SET count = count + 1, datetime = CURRENT_TIMESTAMP WHERE userId = ${userId}`;
            } else {
              dailyVotedSql = `UPDATE dailyvoted SET count = count + 1 WHERE userId = ${userId}`;
            }
          } else {
            // Insert
            dailyVotedSql = `INSERT INTO dailyvoted (userId, count, dateTime) VALUES (${userId}, ${1}, CURRENT_TIMESTAMP)`;
          }
          root.con.query(dailyVotedSql, (err) => {
            if (err) return helper.sendError(err, res);
            return res.status(200).json({ msg: "Oy verildi." });
          });
        });
      });
    });
  });

  //  -------------------- DELETE --------------------  //
  router.delete("/settings", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);

    if (!keys.includes("name")) return helper.sendErrorMissingData(res);

    const sql = `DELETE FROM settings WHERE name = '${args.name}'`;
    root.con.query(sql, (err) => {
      if (err) helper.sendError(err, res);
      res.send({ msg: `${args.name} silindi.` });
    });
  });

  router.delete("/rewardedData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `DELETE FROM rewarded WHERE id='${args.id}'`;
    root.con.query(sql, (err) => {
      if (err) return helper.sendError(err, res);
      res.send({ msg: `Ödül kaldırıldı.` });
    });
  });
  return router;
}

export default routes;
