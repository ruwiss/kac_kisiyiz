import 'dart:async';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool showCodeInputField = false;
  int? timerForResetPassword;
  bool codeVerified = false;

  void startTimerForResetPassword() {
    timerForResetPassword = 120;
    showCodeInputField = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerForResetPassword == null) {
        timer.cancel();
        return;
      }
      if (timerForResetPassword == 0) {
        timer.cancel();
        setTimerForResetPassword(null);
      } else {
        setTimerForResetPassword(timerForResetPassword! - 1);
      }
    });
  }

  void setTimerForResetPassword(int? value) {
    timerForResetPassword = value;
    notifyListeners();
  }

  void setCodeVerified(bool value) {
    codeVerified = value;
    notifyListeners();
  }
}
