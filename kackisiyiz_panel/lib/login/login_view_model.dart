import 'dart:async';
import 'package:kackisiyiz_panel/login/common/login_api_service.dart';
import 'package:kackisiyiz_panel/core/app/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final _loginApiService = LoginApiService();
  String? userToken;

  Future<bool> login(String mail, String password) async {
    setState(ViewState.busy);
    userToken = await _loginApiService.login(mail, password);
    setState(ViewState.idle);
    return userToken != null;
  }
}
