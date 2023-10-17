"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Connector = void 0;
const express_1 = __importDefault(require("express"));
const morgan_1 = __importDefault(require("morgan"));
const dotenv_1 = __importDefault(require("dotenv"));
const mysql2_1 = __importDefault(require("mysql2"));
const cors_1 = __importDefault(require("cors"));
class Connector {
    constructor() {
        dotenv_1.default.config();
        this.app = (0, express_1.default)();
        this.middlewares();
    }
    middlewares() {
        this.app.set("api_secret_key", process.env.API_SECRET_KEY);
        this.app.set("token_expire", process.env.TOKEN_EXPIRE);
        this.app.use((0, cors_1.default)());
        this.app.use((0, morgan_1.default)("dev"));
        this.app.use(express_1.default.urlencoded({ extended: true }));
        this.app.use(express_1.default.json());
    }
    listen() {
        const port = process.env.PORT;
        this.app.listen(port);
        console.log(`http://localhost:${port}`);
        this.connectMysql().then(() => __awaiter(this, void 0, void 0, function* () {
            yield this.createTables();
            yield this.setDefaultValues();
        }));
    }
    connectMysql() {
        return __awaiter(this, void 0, void 0, function* () {
            const access = {
                host: process.env.HOST,
                user: process.env.USER,
                password: process.env.PASSWORD,
                database: process.env.DATABASE,
                multipleStatements: true,
                connectionLimit: 10,
                maxIdle: 10,
                idleTimeout: 60000,
                queueLimit: 0,
                waitForConnections: true,
                typeCast: function (field, next) {
                    if (field.type == "NEWDECIMAL") {
                        var value = field.string();
                        return value === null ? null : Number(value);
                    }
                    return next();
                },
            };
            this.con = mysql2_1.default.createPool(access);
        });
    }
    createTables() {
        return __awaiter(this, void 0, void 0, function* () {
            const sql = "CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY AUTO_INCREMENT, mail VARCHAR(255), password VARCHAR(255), name VARCHAR(255), money DECIMAL(10, 2) NOT NULL DEFAULT '0.00', onesignalId VARCHAR(255));" +
                "CREATE TABLE IF NOT EXISTS bank (id INT PRIMARY KEY AUTO_INCREMENT, userId VARCHAR(255), nameSurname VARCHAR(255), bankName VARCHAR(255), iban VARCHAR(30));" +
                "CREATE TABLE IF NOT EXISTS categories (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255), icon VARCHAR(20));" +
                "CREATE TABLE IF NOT EXISTS surveys (id INT PRIMARY KEY AUTO_INCREMENT, categoryId INT, userId INT, title VARCHAR(255), content VARCHAR(1000), image VARCHAR(250), ch1 INT, ch2 INT, adLink VARCHAR(255), isRewarded DECIMAL(10, 2), isPending BOOL);" +
                "CREATE TABLE IF NOT EXISTS settings (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255), attr VARCHAR(2000));" +
                "CREATE TABLE IF NOT EXISTS voted (id INT PRIMARY KEY AUTO_INCREMENT, surveyId INT, userId INT, vote VARCHAR(3));" +
                "CREATE TABLE IF NOT EXISTS dailyvoted (id INT PRIMARY KEY AUTO_INCREMENT, userId INT, count INT, dateTime DATETIME);" +
                "CREATE TABLE IF NOT EXISTS rewarded (id INT PRIMARY KEY AUTO_INCREMENT, surveyId INT, reward DECIMAL(10, 2));" +
                "CREATE TABLE IF NOT EXISTS resetpassword (id INT PRIMARY KEY AUTO_INCREMENT, mail VARCHAR(255), code VARCHAR(5), dateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP);";
            this.con.query(sql, (err) => {
                if (err)
                    throw err;
            });
        });
    }
    setDefaultValues() {
        return __awaiter(this, void 0, void 0, function* () {
            // Ayarlar Başlangıç
            const datas = [
                {
                    name: "surveyLimit",
                    attr: process.env.SURVEY_LIMIT,
                },
                {
                    name: "appOpenAd",
                    attr: process.env.APP_OPEN_AD,
                },
                {
                    name: "surveyAdDisplayCount",
                    attr: process.env.SURVEY_AD_DISPLAY_COUNT,
                },
                {
                    name: "withdrawalLimit",
                    attr: process.env.WITHDRAWAL_LIMIT,
                },
            ];
            const insertQueries = datas.map((v) => `INSERT INTO settings (name, attr)
        SELECT '${v.name}', '${v.attr}'
        WHERE NOT EXISTS (SELECT 1 FROM settings WHERE name = '${v.name}');`);
            for (let i = 0; i < insertQueries.length; i++) {
                this.con.query(insertQueries[i], (err) => {
                    if (err)
                        throw err;
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
                    this.con.query(insertSql, (err) => {
                        if (err)
                            throw err;
                    });
                }
            });
        });
    }
}
exports.Connector = Connector;
