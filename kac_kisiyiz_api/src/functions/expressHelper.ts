import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import { QueryError } from "mysql2";

export class ExpressHelper {
  debug!: boolean;
  constructor() {
    this.debug = true;
  }

  sendError(err: QueryError, res: Response) {
    console.log(err.message);
    res.status(500).send({
      code: err.errno,
      msg: this.debug ? `HATA: ${err.message}` : "Bir sorun oluştu.",
    });
  }

  sendErrorMissingData(res: Response) {
    res.status(400).send({ msg: "Yanlış istek." });
  }

  getArgsByMethod(req: Request): [any, any[]] {
    const args = req.method == "GET" ? req.query : req.body;
    const keys = Object.keys(args);
    return [args, keys];
  }

  listContainsList(list: any[], items: any[]): boolean {
    let contains: boolean = true;
    for (let i = 0; i < items.length; i++)
      if (!list.includes(items[i])) contains = false;
    return contains;
  }

  createUserToken(user: any, req: Request, isAuth: boolean = true): string {
    const { id, mail, password } = user;
    const payload = {
      id,
      mail,
      password,
      isAuth,
    };
    const apiSecretKey: string = req.app.get("api_secret_key");
    let token: string;
    if (isAuth) {
      token = jwt.sign(payload, apiSecretKey);
    } else {
      token = jwt.sign(payload, apiSecretKey, {
        expiresIn: req.app.get("token_expire"),
      });
    }
    return token;
  }

  areDatesOnSameDay(date1: Date, date2: Date): boolean {
    return (
      date1.getFullYear() === date2.getFullYear() &&
      date1.getMonth() === date2.getMonth() &&
      date1.getDay() === date2.getDay()
    );
  }

  validationForResetPassword(date1: Date, date2: Date): boolean {
    const msBetweenDates = date2.getTime() - date1.getTime();
    const msToMin = msBetweenDates / 60000;
    return msToMin < 10;
  }
  
  randomNumber(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
}
