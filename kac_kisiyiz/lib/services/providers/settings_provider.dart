import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/models/user_model.dart';

class SettingsProvider with ChangeNotifier {
  UserBankModel? userBank;
  String? privacyPolicy;

  void setUserBank(UserBankModel? userBank) {
    this.userBank = userBank;
    notifyListeners();
  }

  void setPrivacyPolicy(String privacyPolicy) {
    this.privacyPolicy = privacyPolicy;
    notifyListeners();
  }

  void resetData() {
    userBank = null;
    //privacyPolicy = null;
    notifyListeners();
  }
}
