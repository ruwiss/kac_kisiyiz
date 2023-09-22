class SurveyModel {
  SurveyModel({
    required this.id,
    required this.category,
    required this.categoryId,
    required this.userId,
    required this.userName,
    required this.title,
    this.content,
    required this.imageUrl,
    required this.choice1,
    required this.choice2,
    this.adLink,
    this.isRewarded,
  });

  final int id;
  final String category;
  final int categoryId;
  final int userId;
  final String userName;
  final String title;
  final String? content;
  final String imageUrl;
   int choice1;
   int choice2;
  final String? adLink;
  final int? isRewarded;

  SurveyModel.fromJson(Map json)
      : id = json['id'],
        category = json['category'],
        categoryId = json['categoryId'],
        userId = json['userId'],
        userName = json['userName'],
        title = json['title'],
        content = json['content'],
        imageUrl = json['image'],
        choice1 = json['ch1'],
        choice2 = json['ch2'],
        adLink = json['adLink'],
        isRewarded = json['isRewarded'];
}
