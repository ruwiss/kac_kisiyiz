"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExpressHelper = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
class ExpressHelper {
    constructor() {
        this.debug = true;
    }
    sendError(err, res) {
        console.log(err.message);
        res.status(500).send({
            code: err.errno,
            msg: this.debug ? `HATA: ${err.message}` : "Bir sorun oluştu.",
        });
    }
    sendErrorMissingData(res) {
        res.status(400).send({ msg: "Yanlış istek." });
    }
    getArgsByMethod(req) {
        const args = req.method == "GET" ? req.query : req.body;
        const keys = Object.keys(args);
        return [args, keys];
    }
    listContainsList(list, items) {
        let contains = true;
        for (let i = 0; i < items.length; i++)
            if (!list.includes(items[i]))
                contains = false;
        return contains;
    }
    createUserToken(user, req, isAuth = true) {
        const { id, mail, password } = user;
        const payload = {
            id,
            mail,
            password,
            isAuth,
        };
        const apiSecretKey = req.app.get("api_secret_key");
        let token;
        if (isAuth) {
            token = jsonwebtoken_1.default.sign(payload, apiSecretKey);
        }
        else {
            token = jsonwebtoken_1.default.sign(payload, apiSecretKey, {
                expiresIn: req.app.get("token_expire"),
            });
        }
        return token;
    }
    areDatesOnSameDay(date1, date2) {
        return (date1.getFullYear() === date2.getFullYear() &&
            date1.getMonth() === date2.getMonth() &&
            date1.getDay() === date2.getDay());
    }
    validationForResetPassword(date1, date2) {
        const msBetweenDates = date2.getTime() - date1.getTime();
        const msToMin = msBetweenDates / 60000;
        return msToMin < 10;
    }
    randomNumber(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
}
exports.ExpressHelper = ExpressHelper;
