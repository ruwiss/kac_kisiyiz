class UserModel {
  UserModel({
    required this.id,
    required this.mail,
    required this.name,
    this.money = 0,
    this.voteCount = 0,
    this.onesignalId,
  });
  final int id;
  final String mail;
  final String name;
  double money;
  int voteCount;
  final String? onesignalId;

  UserModel.fromJson(Map json)
      : id = json['id'],
        mail = json['mail'],
        name = json['name'],
        money = json['money'].runtimeType == int
            ? (json['money'] as int).toDouble()
            : json['money'],
        voteCount = json['voteCount'] ?? 0,
        onesignalId = json['onesignalId'];
}
