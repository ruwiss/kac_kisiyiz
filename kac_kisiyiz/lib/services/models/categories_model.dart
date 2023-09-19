class CategoryModel {
  CategoryModel({this.id, required this.category, required this.iconPoint});
  final int? id;
  final String category;
  final int iconPoint;

  CategoryModel.fromList(List<dynamic> list)
      : id = null,
        category = list[0],
        iconPoint = list[1];

  CategoryModel.fromJson(Map json)
      : category = json['name'],
        iconPoint =
            (json['icon'] as String).isEmpty ? 0xe050 : int.parse(json['icon']),
        id = json['id'];
}
