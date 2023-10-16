class CategoryModel {
  final int? id;
  String? iconData;
  String name;

  CategoryModel(this.id, this.iconData, this.name);

  CategoryModel.empty()
      : id = null,
        iconData = null,
        name = "";

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        iconData = json['icon'],
        name = json['name'];

  Map<String, dynamic> toJson() => {"id": id, "icon": iconData, "name": name};
}
