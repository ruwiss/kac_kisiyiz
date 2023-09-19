import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/extensions/string_extensions.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/auth_response_model.dart';
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
    final utils = locator.get<Utils>();

    if (!mail.isValidEmail()) {
      return utils.showError(context, error: "Mail adresiniz doğru değil.");
    }

    if (mail.isEmpty || password.isEmpty) {
      return utils.showError(context, error: "Eksik bilgi");
    }

    if (!isLogin && (name!.isEmpty || name.length < 5)) {
      return utils.showError(context, error: "İsminizi Girmelisiniz");
    }

    utils.startLoading(context);

    late Response response;

    if (isLogin) {
      response = await _dio.get(KStrings.authUrl,
          queryParameters: {"mail": mail, "password": password});
    } else {
      response = await _dio.post(KStrings.authUrl,
          data: {"name": name, "mail": mail, "password": password});
    }

    resultData = AuthResponse.fromJson(response.data);

    utils.stopLoading(context);

    if (response.statusCode != 200 || resultData.token == null) {
      utils.showError(context, error: resultData.msg);
      return;
    }

    Navigator.of(context).pushReplacementNamed("/home");
  }
}
