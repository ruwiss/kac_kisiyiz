import 'dart:convert';
import 'package:kac_kisiyiz/services/models/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDB {
  late SharedPreferences prefs;

  Future initialize() async {
    await SharedPreferences.getInstance().then((value) => prefs = value);
  }

  void saveUser(AuthResponse authResponse) {
    prefs.setString("user", json.encode(authResponse.toJson()));
  }

  Future deleteUser() async => await prefs.remove("user");

  AuthResponse? getUser() {
    final String? user = prefs.getString("user");
    if (user == null) return null;

    return AuthResponse.fromJson(json.decode(user));
  }

  bool homePageAppVoteButtonClicked() => prefs.containsKey("homePageAppVoteButton");

  void setHomePageAppVoteButtonClicked() => prefs.setBool("homePageAppVoteButton", true);
}
