"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
exports.default = (req, res, next) => {
    const token = req.get("x-access-token");
    if (!token)
        return res.status(401).send("Token bulunmamaktadır.");
    jsonwebtoken_1.default.verify(token, req.app.get("api_secret_key"), (error, decoded) => {
        if (error)
            return res.status(401).send(error.message);
        if (decoded.isAuth)
            return res.status(401).send({ msg: "Token Error" });
        req.body.user = decoded;
        next();
    });
};
