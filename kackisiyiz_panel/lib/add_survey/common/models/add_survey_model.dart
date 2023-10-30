class AddSurveyModel {
  int? id;
  final int categoryId;
  final String title;
  final String content;
  final String image;
  final String? uid;
  final String? adLink;
  final String? reward;
  final String? onesignalId;

  AddSurveyModel({
    this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    required this.image,
    String? uid,
    String? onesignalId,
    String? adLink,
    String? reward,
  })  : uid = uid != null || (uid != null && uid.isEmpty) ? uid : null,
        onesignalId =
            onesignalId != null || (onesignalId != null && onesignalId.isEmpty)
                ? onesignalId
                : null,
        adLink = adLink != null || (adLink != null && adLink.isEmpty)
            ? adLink
            : null,
        reward = reward != null || (reward != null && reward!.isEmpty)
            ? reward
            : null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "title": title,
        "content": content,
        "image": image,
        "userId": uid,
        "adLink": adLink,
        "isRewarded": reward,
        "onesignalId": onesignalId,
      };
}
