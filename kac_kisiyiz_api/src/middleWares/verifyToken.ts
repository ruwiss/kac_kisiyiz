import jwt, { Secret } from "jsonwebtoken";
import { Request, Response, NextFunction } from "express";

export default (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers["x-access-token"] as string;
  if (!token) return res.status(401).send("Token bulunmamaktadır.");
  jwt.verify(
    token,
    req.app.get("api_secret_key") as Secret,
    (error: any, decoded: any) => {
      if (error) return res.status(401).send(error.message);
      if (decoded.isAuth) return res.status(401).send({ msg: "Token Error" });
      req.body.user = decoded;
      next();
    }
  );
};
