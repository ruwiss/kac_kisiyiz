import { Router } from "express";
import { Connector } from "./connector";
import routes from "./routers/mainRouter";
import tokenRouter from "./routers/tokenRouter";

const root = new Connector();
const router = Router();

root.app.use("/api", routes(router, root));
root.app.use("/user", tokenRouter(router, root));

root.listen();
