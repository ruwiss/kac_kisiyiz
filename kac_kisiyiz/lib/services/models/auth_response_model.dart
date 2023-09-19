class AuthResponse {
  AuthResponse({required this.msg, this.name, this.token});
  final String msg;
  final String? name;
  final String? token;

  AuthResponse.fromJson(Map json)
      : msg = json['msg'],
        name = json['name'],
        token = json['token'];
}
