class KStrings {
  // Admob Ads
  static const String insertstitialId =
      "ca-app-pub-3940256099942544/1033173712";
  static const String appOpenId = "ca-app-pub-3940256099942544/3419835294";
  static const String bannerId = "ca-app-pub-3940256099942544/6300978111";

  static const String oneSignalAppId = "2b8c9302-ee74-47e8-b5dc-6d91982a16c6";

  // Backend URL's
  static const String hostUser = "http://192.168.1.110:3000/user";
  static const String hostApi = "http://192.168.1.110:3000/api";

  static const String privacyPolicy = "$hostUser/privacyPolicy";
  static const String settings = "$hostApi/settings";

  static const String authUrl = "$hostUser/auth";
  static const String tokenUrl = "$hostUser/token";

  static const String forgotPassword = "$hostUser/forgotPassword";
  static const String verifyCode = "$hostUser/verifyCode";
  static const String resetPassword = "$hostUser/resetPassword";

  static const String bankAccount = "$hostApi/bank";

  static const String fetchCategoriesUrl = "$hostApi/categories";
  static const String fetchSurveys = "$hostApi/surveys";

  static const String postSurvey = "$hostApi/surveyData";

  static const String patchSurvey = "$hostApi/surveyData";
  static const String patchMoney = "$hostApi/userMoney";
  static const String patchUserInformation = "$hostApi/userInformation";

  static const String deleteUser = "$hostApi/user";
}
