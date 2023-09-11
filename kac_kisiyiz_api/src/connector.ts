import express, { Application } from "express";
import morgan from "morgan";
import dotenv from "dotenv";
import mysql from "mysql";

export class Connector {
  app: Application;
  con!: mysql.Connection;

  constructor() {
    dotenv.config();
    this.app = express();
    this.middlewares();
    this.listen().then(() =>
      this.connectMysql().then(async () => {
        await this.createTables();
        await this.setDefaultValues();
      })
    );
  }

  middlewares() {
    this.app.use(morgan("dev"));
    this.app.use(express.urlencoded({ extended: true }));
    this.app.use(express.json());
  }

  private async listen() {
    const port = process.env.PORT;
    this.app.listen(port);
    console.log(`http://localhost:${port}`);
  }

  private async connectMysql() {
    this.con = mysql.createConnection({
      host: process.env.HOST,
      user: process.env.USER,
      password: process.env.PASSWORD,
      database: process.env.DATABASE,
      multipleStatements: true,
    });

    this.con.connect((err) => {
      if (err) throw err;
      console.log("MySQL Connected!");
    });
  }

  private async createTables() {
    const sql =
      "CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY AUTO_INCREMENT, mail VARCHAR(255), password VARCHAR(255), name VARCHAR(255), money INT, onesignalId VARCHAR(255));" +
      "CREATE TABLE IF NOT EXISTS bank (id INT PRIMARY KEY AUTO_INCREMENT, userId VARCHAR(255), nameSurname VARCHAR(255), bankName VARCHAR(255), iban VARCHAR(30));" +
      "CREATE TABLE IF NOT EXISTS categories (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255), icon VARCHAR(20));" +
      "CREATE TABLE IF NOT EXISTS surveys (id INT PRIMARY KEY AUTO_INCREMENT, categoryId INT, userId INT, title VARCHAR(255), content VARCHAR(1000), image VARCHAR(250), ch1 INT, ch2 INT, adLink VARCHAR(255), isRewarded BOOL, isPending BOOL);" +
      "CREATE TABLE IF NOT EXISTS pending (id INT PRIMARY KEY AUTO_INCREMENT, surveyId INT, userId INT, category VARCHAR(255), title VARCHAR(255), content VARCHAR(1000));" +
      "CREATE TABLE IF NOT EXISTS settings (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255), attr VARCHAR(2000));" +
      "CREATE TABLE IF NOT EXISTS voted (id INT PRIMARY KEY AUTO_INCREMENT, surveyId INT, userId INT, vote VARCHAR(3));" +
      "CREATE TABLE IF NOT EXISTS rewarded (id INT PRIMARY KEY AUTO_INCREMENT, surveyId INT, reward DECIMAL(10, 2));";
    await this.con.query(sql, (err) => {
      if (err) throw err;
    });
  }

  private async setDefaultValues() {
    const datas = [
      {
        name: "updateRequired",
        attr: process.env.UPDATE_REQUIRED,
      },
      { name: "surveyLimit", attr: process.env.SURVEY_LIMIT },
    ];
    const insertQueries = datas.map(
      (v) =>
        `INSERT INTO settings (name, attr) VALUES ('${v.name}', '${v.attr}')`
    );

    for (let i = 0; i < insertQueries.length; i++) {
      const querySql = `SELECT id FROM settings WHERE name = '${datas[i].name}'`;
      await this.con.query(querySql, async (err, result) => {
        if (err) throw err;
        if (!result[0]) {
          await this.con.query(insertQueries[i], (err) => {
            if (err) throw err;
            this.con.commit();
          });
        }
      });
    }
  }
}
