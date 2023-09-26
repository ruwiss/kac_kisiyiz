class SettingsModel {
  SettingsModel({this.privacyPolicy, this.surveyAdDisplayCount});
  String? privacyPolicy;
  int? surveyAdDisplayCount;

  SettingsModel.fromData(List data) {
    for (Map i in data) {
      if (i["name"] == "surveyAdDisplayCount") {
        surveyAdDisplayCount = int.parse(i["attr"]);
      }
    }
  }
}
