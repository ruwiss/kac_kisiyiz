import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/auth_page/auth_page.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/extensions/string_extensions.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/auth_response_model.dart';
import 'package:kac_kisiyiz/services/providers/auth_provider.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/strings.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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

  Future forgotPassword(BuildContext context, {required String mail}) async {
    Utils.startLoading(context);
    final response =
        await _dio.post(KStrings.forgotPassword, data: {"mail": mail});
    if (response.statusCode == 200) {
      if (context.mounted) {
        Utils.showInfo(context, message: response.data['msg']);
      }
    } else {
      if (context.mounted) {
        locator.get<AuthProvider>().setTimerForResetPassword(null);
        Utils.showError(context,
            error: response.statusCode == 401
                ? response.data['msg']
                : "Bir sorun oluştu.");
      }
    }
    if (context.mounted) Utils.stopLoading(context);
  }

  Future verifyCode(
    BuildContext context, {
    required String mail,
    required String code,
  }) async {
    Utils.startLoading(context);
    final response = await _dio
        .post(KStrings.verifyCode, data: {"mail": mail, "code": code});

    if (response.statusCode == 200) {
      if (context.mounted) {
        final authProvider = locator.get<AuthProvider>();
        authProvider.setCodeVerified(true);
        authProvider.setTimerForResetPassword(null);
      }
    } else {
      if (context.mounted) {
        Utils.showError(context,
            error: response.statusCode == 401
                ? response.data['msg']
                : "Bir sorun oluştu.");
      }
    }
    if (context.mounted) Utils.stopLoading(context);
  }

  Future resetPassword(BuildContext context,
      {required String code, required String password}) async {
    Utils.startLoading(context);

    final response = await _dio.post(KStrings.resetPassword,
        data: {"code": code, "password": password});

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.pop(context);
        Utils.showInfo(context, message: response.data['msg']);
        final authProvider = locator.get<AuthProvider>();
        authProvider.setCodeVerified(false);
        authProvider.setCodeInputFiled(false);
      }
    } else {
      if (context.mounted) {
        Utils.showError(context,
            error: response.statusCode == 401
                ? response.data['msg']
                : "Bir sorun oluştu.");
      }
    }

    if (context.mounted) Utils.stopLoading(context);
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
      response = await _dio.post(KStrings.authUrl, data: {
        "name": name,
        "mail": mail,
        "password": password,
        "onesignalId": OneSignal.User.pushSubscription.id
      });
      if (response.statusCode != 200) {
        Utils.stopLoading(context);
        resultData = AuthResponse.fromJson(response.data);
        Utils.showError(context, error: resultData.msg);
        return;
      }
    }
    if (!isLogin) {
      Utils.stopLoading(context);
      auth(context: context, mail: mail, password: password, isLogin: true);
      return;
    }
    resultData = AuthResponse.fromJson(response.data);

    Utils.stopLoading(context);

    if (response.statusCode != 200 || resultData.token == null) {
      Utils.showError(context, error: resultData.msg);
      return;
    }
    locator.get<MyDB>().saveUser(resultData);

    Navigator.of(context).pushReplacementNamed("/home");
  }

  Future signOut(BuildContext context) async {
    final navigator = Navigator.of(context);

    await locator.get<MyDB>().deleteUser();
    OneSignal.logout();
    locator.get<HomeProvider>().setCurrentMenu(MenuItems.kackisiyiz);
    navigator.pushNamedAndRemoveUntil("/", (route) => route is AuthPage);
  }
}
