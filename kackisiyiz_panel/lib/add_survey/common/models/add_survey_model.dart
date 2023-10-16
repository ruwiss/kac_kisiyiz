class AddSurveyModel {
  int? id;
  final int categoryId;
  final String title;
  final String content;
  final String image;
  final String? uid;
  final String? adLink;
  final String? reward;

  AddSurveyModel({
    this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    required this.image,
    String? uid,
    String? adLink,
    String? reward,
  })  : uid = uid != null || uid!.isEmpty ? uid : null,
        adLink = adLink != null || adLink!.isEmpty ? adLink : null,
        reward = reward != null || reward!.isEmpty ? reward : null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "title": title,
        "content": content,
        "image": image,
        "userId": uid,
        "adLink": adLink,
        "isRewarded": reward,
      };
}
