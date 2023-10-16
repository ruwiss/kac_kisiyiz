class SurveyModel {
  SurveyModel({
    required this.id,
    required this.category,
    required this.categoryId,
    required this.userId,
    this.userName,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.choice1,
    required this.choice2,
    this.adLink,
    required this.isPending,
    this.isRewarded,
  });

  final int id;
  final String category;
  final int categoryId;
  final int userId;
  String? userName;
  final String title;
  final String content;
  final String? imageUrl;
  int choice1;
  int choice2;
  final String? adLink;
  final bool isPending;
  final double? isRewarded;

  SurveyModel.fromJson(Map<String, dynamic> json)
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
        isPending = json['isPending'] == 1,
        isRewarded = json['isRewarded'].runtimeType == int ? (json['isRewarded'] as int).toDouble() : json['isRewarded'];

  Map<String, String> toJsonString() => {
        "id": "$id",
        "category": category,
        "categoryId": "$categoryId",
        "userId": "$userId",
        "userName": userName ?? "",
        "title": title,
        "content": content,
        "image": "$imageUrl",
        "ch1": "$choice1",
        "ch2": "$choice2",
        "adLink": "$adLink",
        "isPending": "$isPending",
        "isRewarded": "$isRewarded",
      };

  SurveyModel.fromJsonString(Map<String, String> json)
      : id = int.parse(json['id']!),
        category = json['category']!,
        categoryId = int.parse(json['categoryId']!),
        userId = int.parse(json['userId']!),
        userName = json['userName']!,
        title = json['title']!,
        content = json['content']!,
        imageUrl = json['image']! == "null" ? null : json['image']!,
        choice1 = int.parse(json['ch1']!),
        choice2 = int.parse(json['ch2']!),
        adLink = json['adLink'] == "null" ? null : json['adLink'],
        isPending = bool.parse(json['isPending']!),
        isRewarded = double.parse(json['isRewarded']!);
}
