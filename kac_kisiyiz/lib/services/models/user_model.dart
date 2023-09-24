class UserModel {
  UserModel(this.id, this.mail, this.name, this.onesignalId);
  final int id;
  final String mail;
  final String name;
  final String? onesignalId;
  double money = 0;
  int voteCount = 0;

  UserModel.fromJson(Map json)
      : id = json['id'],
        mail = json['mail'],
        name = json['name'],
        money = json['money'].runtimeType == int
            ? (json['money'] as int).toDouble()
            : json['money'],
        voteCount = json['voteCount'] ?? 0,
        onesignalId = json['onesignalId'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "mail": mail,
        "name": name,
        "onesignalId": onesignalId,
        "money": money,
        "voteCount": voteCount
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
}
