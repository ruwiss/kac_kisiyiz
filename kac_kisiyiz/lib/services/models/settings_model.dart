class SettingsModel {
  String name;
  String attr;

  SettingsModel(this.name, this.attr);

  SettingsModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        attr = json['attr'];

  Map<String, dynamic> toJson() => {"name": name, "attr": attr};
}
