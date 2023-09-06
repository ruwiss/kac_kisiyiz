class SurveyModel {
  SurveyModel({
    required this.id,
    required this.category,
    required this.categoryId,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.choice1,
    required this.choice2,
  });

  final int id;
  final String category;
  final String categoryId;
  final String userId;
  final String userName;
  final String title;
  final String content;
  final String imageUrl;
  final int choice1;
  final int choice2;
}
