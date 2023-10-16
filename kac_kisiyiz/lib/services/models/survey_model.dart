class SurveyModel {
  SurveyModel({
    required this.id,
    required this.category,
    required this.categoryId,
    required this.userId,
    this.userName,
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
  final String? userName;
  final String title;
  final String? content;
  final String imageUrl;
  int choice1;
  int choice2;
  final String? adLink;
  final double? isRewarded;

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
        isRewarded = json['isRewarded'].runtimeType == int
            ? (json['isRewarded'] as int).toDouble()
            : json['isRewarded'];

  factory SurveyModel.dummy() => SurveyModel(
        id: 0,
        category: "Örnek Kategori",
        categoryId: 1,
        userId: 1,
        userName: "İsim Soyisim",
        title: "Örnek başlık metni. " * 2,
        imageUrl: "",
        choice1: 0,
        choice2: 0,
        content:
            "Örnek içerik metni ve bu içeriğin boş bir yazı olmaması haricinde sorun yok." *
                2,
      );
}
