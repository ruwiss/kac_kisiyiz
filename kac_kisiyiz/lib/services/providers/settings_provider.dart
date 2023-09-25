import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  String? privacyPolicy;


  void setPrivacyPolicy(String privacyPolicy) {
    this.privacyPolicy = privacyPolicy;
    notifyListeners();
  }
}
