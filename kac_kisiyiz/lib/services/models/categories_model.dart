class CategoryModel {
  CategoryModel({required this.category, required this.iconPoint});
  
  CategoryModel.fromList(List<dynamic> list)
      : category = list[0],
        iconPoint = list[1];
  final String category;
  final int iconPoint;
}
