import { Router } from "express";
import { ExpressHelper } from "../functions/expressHelper";
import { Connector } from "../connector";
import { RowDataPacket, ResultSetHeader } from "mysql2";

function routes(router: Router, root: Connector): Router {
  const helper = new ExpressHelper();
  
  //  -------------------- GETTER --------------------  //

  router.get("/settings", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);

    const sql = keys.includes("name")
      ? `SELECT * FROM settings WHERE name = '${args.name}'`
      : `SELECT * FROM settings`;

    root.con.query(sql, (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.send(result);
      }
    });
  });

  router.get("/bank", (req, res) => {
    const userId = req.body.user.id;

    const sql = `SELECT * FROM bank WHERE userId = ${userId}`;

    root.con.query<RowDataPacket[]>(sql, (err, result) => {
      if (err) return helper.sendError(err, res);

      if (result[0]) {
        return res.json(result[0]);
      } else {
        return res.json({});
      }
    });
  });

  router.get("/topUsers", (_, res) => {
    const sql = `SELECT u.*, b.nameSurname, b.bankName, b.iban, v.voteCount
    FROM users u
    LEFT JOIN bank b ON b.userId = u.id
    LEFT JOIN (SELECT userId, COUNT(id) as voteCount FROM voted GROUP BY userId) v ON v.userId = u.id
    ORDER BY money DESC
    LIMIT 5;`;
    root.con.query(sql, (err, result) => {
      if (err) return helper.sendError(err, res);
      return res.json(result);
    });
  });

  router.get("/surveyData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM surveys WHERE id = ?`;

    root.con.query<RowDataPacket[]>(sql, [args.id], (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json(result[0]);
      }
    });
  });

  router.get("/surveys", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    let sql: string;
    let sqlArgs: any[];

    const userId = req.body.user.id;
    const forPanel = keys.includes("forPanel");

    function getLimit(): number {
      let envLimit = parseInt(process.env.SURVEY_LIMIT as string);
      const sql = `SELECT count FROM dailyvoted WHERE userId = ${userId}`;
      root.con.query<RowDataPacket[]>(sql, (err, result) => {
        if (err) {
          return helper.sendError(err, res);
        } else if (result[0]) {
          envLimit = envLimit - result[0].count;
        }
      });
      return envLimit;
    }
    userId;

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
      ORDER BY s.ch2 DESC
      LIMIT ${envLimit};`;
      sqlArgs = [userId, args.categoryId];
    } else if (forPanel) {
      // [pending] or [rewarded]
      const filter = args.filter;

      const extra = !keys.includes("search")
        ? ""
        : `WHERE s.title LIKE '%${args.search}%'`;
      sql = `SELECT s.*,  c.name AS category, u.name AS userName, u.onesignalId AS onesignalId
      FROM surveys s
      LEFT JOIN categories c ON s.categoryId = c.id
      LEFT JOIN users u ON s.userId = u.id
      ${extra}
      ORDER BY ${filter == "pending" ? "s.isPending" : "s.isRewarded"} DESC
      LIMIT ${process.env.SURVEY_LIMIT};`;
      sqlArgs = [userId];
    } else {
      const envLimit = getLimit();
      if (envLimit < 1) return res.send([]);
      sql = `SELECT s.*,  c.name AS category, u.name AS userName
      FROM surveys s
      LEFT JOIN voted v ON s.id = v.surveyId AND v.userId = ?
      LEFT JOIN categories c ON s.categoryId = c.id
      LEFT JOIN users u ON s.userId = u.id
      WHERE v.id IS NULL AND s.isPending = 0
      ORDER BY s.ch2 DESC
      LIMIT ${envLimit};`;
      sqlArgs = [userId];
    }

    root.con.query(sql, sqlArgs, (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json(result);
      }
    });
  });

  router.get("/categories", (_, res) => {
    const sql = `SELECT * FROM categories ORDER BY name ASC`;

    root.con.query(sql, (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.send(result);
      }
    });
  });

  router.get("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM categories WHERE id = ?`;

    root.con.query<RowDataPacket[]>(sql, [args.id], (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json(result[0]);
      }
    });
  });

  router.get("/rewardedData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `SELECT * FROM rewarded WHERE id = ?`;

    root.con.query<RowDataPacket[]>(sql, [args.id], (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.send(result[0]);
      }
    });
  });

  //  -------------------- SETTER --------------------  //

  router.post("/settings", (req, res) => {
    const [args] = helper.getArgsByMethod(req);

    const sql = `INSERT INTO settings (name, attr) VALUES (?, ?)`;
    const values = [args.name, args.attr];

    root.con.query(sql, values, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: "Ayarlar kaydedildi." });
      }
    });
  });

  router.post("/bank", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["nameSurname", "bankName", "iban"];
    const userId = req.body.user.id;

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    // Banka hesabı var mı kontrol etme
    const sql = `SELECT id FROM bank WHERE userId = ${userId}`;

    root.con.query<RowDataPacket[]>(sql, (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else if (result[0]) {
        const updateSql = `UPDATE bank SET nameSurname = ?, bankName = ?, iban = ? WHERE userId = ${userId}`;
        const values = [args.nameSurname, args.bankName, args.iban];

        root.con.query(updateSql, values, (err) => {
          if (err) {
            return helper.sendError(err, res);
          } else {
            return res.json({ msg: "Ödeme bilgileri güncellendi." });
          }
        });
      } else {
        const insertSql = `INSERT INTO bank (userId, nameSurname, bankName, iban) VALUES ('${userId}', ?, ?, ?)`;
        const values = [args.nameSurname, args.bankName, args.iban];

        root.con.query(insertSql, values, (err) => {
          if (err) {
            return helper.sendError(err, res);
          } else {
            return res.json({ msg: "Banka hesabı kaydedildi." });
          }
        });
      }
    });
  });

  router.post("/surveyData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["categoryId", "title", "content"];

    const userId =
      keys.includes("userId") && args.userId != null && args.userId != ""
        ? args.userId
        : req.body.user.id;

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const isPending = keys.includes("isPending") && args.isPending;

    const sql = `INSERT INTO surveys (categoryId, userId, title, content, image, ch1, ch2, adLink, isRewarded, isPending) VALUES (?,?,?,?,?,?,?,?,?,?)`;
    const values = [
      args.categoryId,
      userId,
      args.title,
      args.content,
      args.image,
      0,
      0,
      args.adLink,
      args.isRewarded ?? 0.0,
      isPending,
    ];

    root.con.query(sql, values, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: "Anket başarıyla eklendi." });
      }
    });
  });

  router.post("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["name", "icon"];

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `INSERT INTO categories (name, icon) VALUES ('${args.name}', '${args.icon}')`;
    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: `${args.name} kategorisi eklendi.` });
      }
    });
  });

  router.post("/rewardedData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["surveyId", "reward"];
    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `INSERT INTO rewarded (surveyId, reward) VALUES ('${args.surveyId}', '${args.reward}')`;

    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({
          msg: `Ödüllü anket ${args.reward}₺ olarak eklendi.`,
        });
      }
    });
  });

  //  ----------------- PUT / PATCH -----------------  //
  router.patch("/settings", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!helper.listContainsList(keys, ["name", "attr"]))
      return helper.sendErrorMissingData(res);

    const sql = `UPDATE settings SET attr = '${args.attr}' WHERE name = '${args.name}'`;
    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: `${args.name} Başarıyla güncellendi.` });
      }
    });
  });

  router.patch("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = ["id", "name", "icon"];
    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `UPDATE categories SET name = '${args.name}', icon='${args.icon}' WHERE id = '${args.id}'`;
    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({
          msg: `id(${args.id}) ${args.name} olarak başarıyla güncellendi`,
        });
      }
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
      if (err) {
        return helper.sendError(err, res);
      } else {
        // Kullanıcı oylarına, kullanıcıyı ekleme işlemi
        const sql = `INSERT INTO voted (surveyId, userId, vote) VALUES (?, ?, ?)`;
        const values = [args.id, userId, args.vote];
        root.con.query(sql, values, (err) => {
          if (err) {
            return helper.sendError(err, res);
          } else {
            // Kullanıcının günlük yaptığı oylama sayısında arttırma işlemi
            const sql = `SELECT * FROM dailyvoted WHERE userId = ${userId}`;
            root.con.query<RowDataPacket[]>(sql, (err, result) => {
              if (err) {
                return helper.sendError(err, res);
              } else {
                let dailyVotedSql: string;
                if (result[0]) {
                  // Patch
                  const mysqlDate = new Date(result[0].dateTime);
                  const currentDate = new Date();
                  const isSameDay = helper.areDatesOnSameDay(
                    mysqlDate,
                    currentDate
                  );
                  if (isSameDay) {
                    dailyVotedSql = `UPDATE dailyvoted SET count = count + 1 WHERE userId = ${userId}`;
                  } else {
                    dailyVotedSql = `UPDATE dailyvoted SET count = 1, dateTime = CURRENT_TIMESTAMP WHERE userId = ${userId}`;
                  }
                } else {
                  // Insert
                  dailyVotedSql = `INSERT INTO dailyvoted (userId, count, dateTime) VALUES (${userId}, ${1}, CURRENT_TIMESTAMP)`;
                }
                root.con.query(dailyVotedSql, (err) => {
                  if (err) {
                    return helper.sendError(err, res);
                  } else {
                    return res.status(200).json({ msg: "Oy verildi." });
                  }
                });
              }
            });
          }
        });
      }
    });
  });

  router.patch("/editSurvey", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const requirements = [
      "id",
      "categoryId",
      "title",
      "content",
      "image",
      "userId",
      "adLink",
      "isRewarded",
    ];

    if (!helper.listContainsList(keys, requirements))
      return helper.sendErrorMissingData(res);

    const sql = `UPDATE surveys SET categoryId = ?, title = ?, content = ?, image = ?, userId = ?, adLink = ?, isRewarded = ?, isPending = ? WHERE id = ?`;
    const values = [
      args.categoryId,
      args.title,
      args.content,
      args.image,
      args.userId,
      args.adLink ?? "",
      args.isRewarded ?? 0.0,
      0,
      args.id,
    ];

    root.con.query(sql, values, (err) => {
      if (err) return helper.sendError(err, res); 
      return res.status(200).json({ msg: "OK" });
    });
  });

  router.patch("/userMoney", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    const userId = keys.includes("userId") ? args.userId : req.body.user.id;

    console.log(args.moneyAmount);

    const sql = `UPDATE users SET money = money + ? WHERE id = ?`;
    const values = [args.moneyAmount, userId];

    root.con.query(sql, values, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.status(200).json({ msg: "OK" });
      }
    });
  });

  router.patch("/userInformation", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys[0]) return helper.sendErrorMissingData(res);
    const user = req.body.user;
    let sql: string;
    let values: any[];

    const wrongPassword = () =>
      res.status(401).json({ msg: "Mevcut şifreniz yanlış." });

    if (helper.listContainsList(keys, ["name", "newPassword", "oldPassword"])) {
      console.log(args.oldPassword, user.password);
      if (args.oldPassword != user.password) return wrongPassword();
      sql = `UPDATE users SET name = ?, password = ? WHERE id = ${user.id}`;
      values = [args.name, args.newPassword];
    } else if (keys.includes("name")) {
      sql = `UPDATE users SET name = ? WHERE id = ${user.id}`;
      values = [args.name];
    } else if (keys.includes("newPassword")) {
      if (args.oldPassword != user.password) return wrongPassword();
      sql = `UPDATE users SET password = ? WHERE id = ${user.id}`;
      values = [args.newPassword];
    } else {
      return helper.sendErrorMissingData(res);
    }

    root.con.query(sql, values, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: "Bilgileriniz güncellendi." });
      }
    });
  });

  //  -------------------- DELETE --------------------  //
  router.delete("/settings", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);

    if (!keys.includes("name")) return helper.sendErrorMissingData(res);

    const sql = `DELETE FROM settings WHERE name = '${args.name}'`;

    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: `${args.name} silindi.` });
      }
    });
  });

  router.delete("/surveyData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);

    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `DELETE FROM surveys WHERE id = '${args.id}'`;

    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: "OK" });
      }
    });
  });

  router.delete("/categoryData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `DELETE FROM categories WHERE id = ${args.id}`;
    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: `Kategori kaldırıldı.` });
      }
    });
  });

  router.delete("/rewardedData", (req, res) => {
    const [args, keys] = helper.getArgsByMethod(req);
    if (!keys.includes("id")) return helper.sendErrorMissingData(res);

    const sql = `DELETE FROM rewarded WHERE id='${args.id}'`;

    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: `Ödül kaldırıldı.` });
      }
    });
  });

  router.delete("/bank", (req, res) => {
    const sql = `DELETE FROM bank WHERE userId = ${req.body.user.id}`;

    root.con.query<ResultSetHeader>(sql, (err, result) => {
      if (err) {
        return helper.sendError(err, res);
      } else if (result.affectedRows > 0) {
        return res.send({ msg: "Ödeme yöntemi silindi." });
      } else {
        return res.send({ msg: "Zaten kayıtlı bir ödeme yöntemi yok." });
      }
    });
  });

  router.delete("/user", (req, res) => {
    const userId = req.body.user.id;
    const sql =
      `DELETE FROM users WHERE id = ${userId};` +
      `DELETE FROM bank WHERE userId = ${userId};` +
      `DELETE FROM dailyvoted WHERE userId = ${userId};` +
      `DELETE FROM voted WHERE userId = ${userId};`;

    root.con.query(sql, (err) => {
      if (err) {
        return helper.sendError(err, res);
      } else {
        return res.json({ msg: "Hesabınız kalıcı olarak silindi." });
      }
    });
  });

  return router;
}

export default routes;