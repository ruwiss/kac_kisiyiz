class KStrings {
  static const String hostUser = "http://192.168.1.110:3000/user";
  static const String hostApi = "http://192.168.1.110:3000/api";

  static const String authUrl = "$hostUser/auth";
  static const String tokenUrl = "$hostUser/token";

  static const String bankAccount = "$hostApi/bank";

  static const String fetchCategoriesUrl = "$hostApi/categories";
  static const String fetchSurveys = "$hostApi/surveys";

  static const String postSurvey = "$hostApi/surveyData";

  static const String patchSurvey = "$hostApi/surveyData";
  static const String patchMoney = "$hostApi/userMoney";
}
