import 'users_model.dart';

class TopUserModel extends Users {
  final String? nameSurname;
  final String? bankName;
  final String? iban;
  final int voteCount;
  TopUserModel({
    required super.id,
    required super.name,
    required super.mail,
    required super.money,
    required super.onesignalId,
    required this.nameSurname,
    required this.bankName,
    required this.iban,
    required this.voteCount,
  });

  TopUserModel.fromJson(Map json)
      : nameSurname = json['nameSurname'],
        bankName = json['bankName'],
        iban = json['iban'],
        voteCount = json['voteCount'],
        super(
          id: json['id'],
          mail: json['mail'],
          money: json['money'].toString(),
          name: json['name'],
          onesignalId: json['onesignalId'],
        );
}
