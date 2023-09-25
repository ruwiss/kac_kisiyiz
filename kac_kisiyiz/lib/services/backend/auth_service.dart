import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/auth_page.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/extensions/string_extensions.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/auth_response_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/strings.dart';

class AuthService {
  final _dio = Dio();
  late AuthResponse resultData;

  AuthService() {
    _dio.options = BaseOptions(
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
  }

  Future auth(
      {required context,
      String? name,
      required String mail,
      required String password,
      required bool isLogin}) async {
    if (!mail.isValidEmail()) {
      return Utils.showError(context, error: "Mail adresiniz doğru değil.");
    }

    Utils.startLoading(context);

    late Response response;

    if (isLogin) {
      response = await _dio.get(KStrings.authUrl,
          queryParameters: {"mail": mail, "password": password});
    } else {
      response = await _dio.post(KStrings.authUrl,
          data: {"name": name, "mail": mail, "password": password});
    }
    if (!isLogin) {
      auth(context: context, mail: mail, password: password, isLogin: true);
      return;
    }
    resultData = AuthResponse.fromJson(response.data);
    locator.get<MyDB>().saveUser(resultData);

    Utils.stopLoading(context);

    if (response.statusCode != 200 || resultData.token == null) {
      Utils.showError(context, error: resultData.msg);
      return;
    }

    Navigator.of(context).pushReplacementNamed("/home");
  }

  Future signOut(BuildContext context) async {
    final navigator = Navigator.of(context);

    await locator.get<MyDB>().deleteUser();

    locator.get<HomeProvider>().setCurrentMenu(MenuItems.kackisiyiz);
    navigator.pushNamedAndRemoveUntil("/", (route) => route is AuthPage);
  }
}
