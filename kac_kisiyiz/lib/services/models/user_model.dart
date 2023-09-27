class UserModel {
  UserModel(this.id, this.mail, this.password, this.name, this.bankAccount);
  final int id;
  final String mail;
  String password;
  String name;
  double money = 0;
  int voteCount = 0;
  UserBankModel? bankAccount;

  UserModel.fromJson(Map json)
      : id = json['id'],
        mail = json['mail'],
        password = json['password'],
        name = json['name'],
        money = json['money'].runtimeType == int
            ? (json['money'] as int).toDouble()
            : json['money'],
        voteCount = json['voteCount'] ?? 0,
        bankAccount = json["bankAccount"] == null
            ? null
            : UserBankModel.fromJson(json['bankAccount']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "mail": mail,
        "password": password,
        "name": name,
        "money": money,
        "voteCount": voteCount,
        "bankAccount": bankAccount?.toJson(),
      };
}

class UserBankModel {
  UserBankModel(this.nameSurname, this.bankName, this.iban);
  final String nameSurname;
  final String bankName;
  final String iban;

  UserBankModel.fromJson(Map json)
      : nameSurname = json['nameSurname'],
        bankName = json['bankName'],
        iban = json['iban'];

  Map<String, dynamic> toJson() => {
        "nameSurname": nameSurname,
        "bankName": bankName,
        "iban": iban,
      };
}
