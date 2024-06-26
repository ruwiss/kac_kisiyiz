import 'package:kac_kisiyiz/services/models/user_model.dart';

class AuthResponse {
  AuthResponse({required this.msg, this.user, this.token});
  final String msg;
  final UserModel? user;
  final String? token;

  AuthResponse.fromJson(Map json)
      : msg = json['msg'],
        user = json['user'] == null ? null : UserModel.fromJson(json['user']),
        token = json['token'];

  Map<String, dynamic> toJson() =>
      {"msg": msg, "user": user?.toJson(), "token": token};
}
