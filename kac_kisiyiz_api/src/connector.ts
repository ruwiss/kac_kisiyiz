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
  }

  middlewares() {
    this.app.set("api_secret_key", process.env.API_SECRET_KEY);
    this.app.set("token_expire", process.env.TOKEN_EXPIRE);
    this.app.use(morgan("dev"));
    this.app.use(express.urlencoded({ extended: true }));
    this.app.use(express.json());
  }

  listen() {
    const port = process.env.PORT;
    this.app.listen(port);
    console.log(`http://localhost:${port}`);
    this.connectMysql().then(async () => {
      await this.createTables();
      await this.setDefaultValues();
    });
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
    // Ayarlar Başlangıç
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
    // Ayarlar Bitiş

    // Kategoriler Başlangıç
    const categoriesSql = `SELECT id FROM categories LIMIT 1`;
    this.con.query(categoriesSql, (_, result) => {
      if (!result[0]) {
        const insertSql = `INSERT INTO categories (name, icon) VALUES 
        ("80'ler", "0xf05ff"),("90'lar", "0xf05ff"),("Aile", "0xe257"),("Alışkanlık", "0xe531"),("Alışveriş", "0xf37a"),("Arabalar", "0xe531"),("Arkadaşlar", "0xe492"),("Astroloji", "0xe5fa"),
        ("Basketbol", "0xe5e6"),("Basılı Yayın", "0xf0541"),("Batıl İnançlar", "0xf045e"),("Bebek Çocuk", "0xe161"),("Beslenme", "0xe2aa"),("Borsa", "0xe2e3"),("Cinsellik", "0xe30e"),("Dizi", "0xe40d"),
        ("Doğa", "0xe67c"),("Döviz", "0xe07a"),("Dünya", "0xe67c"),("Ekonomi", "0xe0b2"),("Estetik", "0xe881"),("Ev Hali", "0xf06d6"),("Eğitim", "0xf33c"),("Eğlence", "0xf3a8"),("Felsefe", "0xe654"),
        ("Fotoğraf", "0xe4c1"),("Futbol", "0xf3cb"),("Futbol Magazin", "0xf01bd"),("Futbol Mizah", "0xf01bd"),("Geri Dönüşüm", "0xef55"),("Gündem", "0xe6de"),("Günlük", "0xef53"),("Güzellik", "0xe06b"),
        ("Hastalıklar", "0xeeb9"),("Hava Durumu", "0xef62"),("Hayvanlar", "0xe4a1"),("Hepsi", "0xe07f"),("Hobiler", "0xf7b2"),("Huylar", "0xe8e6"),("İndirim", "0xf06bd"),("Kadınlar", "0xf05ab"),
        ("Kediler", "0xe4a1"),("Keyif", "0xef4f"),("Kitaplar", "0xe0ef"),("Kişisel Bakım", "0xe06b"),("Kişisel Gelişim", "0xe086"),("Klasik Oyun", "0xe927"),("Klişeler", "0xe6e1"),("Kozmetik", "0xf0695"),
        ("Kripto Para", "0xf06bc"),("Kutlamalar", "0xe149"),("Köpekler", "0xe4a1"),("Magazin", "0xe051"),("Makyaj", "0xe06b"),("Meslek", "0xe6f2"),("Mobil Oyunlar", "0xe927"),("Moda", "0xe21e"),
        ("Motor Sporları", "0xe40a"),("Müzik", "0xe415"),("Otomotiv", "0xe13d"),("Oyuncular", "0xf0072"),("Para", "0xe3f7"),("Pilates", "0xe29b"),("Psikoloji", "0xe4ef"),("Resim", "0xe332"),
        ("Sanat", "0xe9db"),("Sağlık", "0xf17e"),("Sağlık Hizmetleri", "0xe396"),("Seyahat", "0xf0113"),("Sinema", "0xe40f"),("Sosyal Medya", "0xe5d1"),("Spor", "0xe2fd"),("Tabular", "0xe333"),
        ("Takıntılar", "0xf04c5"),("Teknoloji", "0xe32c"),("Televizyon", "0xe687"),("Trendler", "0xe67f"),("Ulaşım", "0xe1f3"),("Yarışmalar", "0xe63f"),("Yatırım", "0xea44"),("Yaşam", "0xf07a0"),
        ("Yemek", "0xe2aa"),("Yolculuk", "0xe55e"),("YouTube", "0xe6a1"), ("İletişim", "0xe3c4"),("İlişkiler", "0xf0838"),("İçecek", "0xe391"),("İş Hayatı", "0xe6f2"),("Şans", "0xe7fc"),("Şehirler", "0xe3a8");`;
        this.con.query(insertSql);
      }
    });
  }
}
