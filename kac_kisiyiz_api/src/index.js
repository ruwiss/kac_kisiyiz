"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const connector_1 = require("./connector");
const mainRouter_1 = __importDefault(require("./routers/mainRouter"));
const tokenRouter_1 = __importDefault(require("./routers/tokenRouter"));
const verifyToken_1 = __importDefault(require("./middleWares/verifyToken"));
const root = new connector_1.Connector();
const router = (0, express_1.Router)();
root.app.use("/api", verifyToken_1.default);
root.app.use("/api", (0, mainRouter_1.default)(router, root));
root.app.use("/user", (0, tokenRouter_1.default)(router, root));
root.listen();
