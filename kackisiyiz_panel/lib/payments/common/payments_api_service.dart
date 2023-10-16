import 'package:dio/dio.dart';
import 'package:kackisiyiz_panel/core/constants/strings.dart';
import 'package:kackisiyiz_panel/core/services/http_service.dart';
import '../../core/app/locator.dart';
import '../../core/constants/hosts.dart';
import 'models/top_user_model.dart';

class PaymentsApiService {
  final _http = locator<HttpService>();
  Future<List<TopUserModel>?> getTopUsers() async {
    final response = await _http.request(
        url: KHost.topUsers, method: HttpMethod.get, withToken: true);

    if (response == null || response.statusCode != 200) return null;
    List<TopUserModel> topUsers = [];
    for (var i in response.data) {
      topUsers.add(TopUserModel.fromJson(i));
    }
    return topUsers;
  }

  Future<bool> reduceUserMoney(TopUserModel topUserModel) async {
    final response = await _http.request(
        url: KHost.userMoney,
        method: HttpMethod.patch,
        withToken: true,
        data: {
          "moneyAmount": -double.parse(topUserModel.money),
          "userId": topUserModel.id
        });
    await _sendNotificationToUser(topUserModel);
    return response != null && response.statusCode == 200;
  }

  Future _sendNotificationToUser(TopUserModel topUserModel) async {
    await Dio().post(
      KHost.onesignalRestApi,
      options:
          Options(headers: {'Content-Type': 'application/json; charset=UTF-8'}),
      data: {
        "app_id": KStrings.onesignalAppId,
        "include_subscription_ids": [topUserModel.onesignalId],
        "headings": {"en": "Ödemeniz Yapıldı"},
        "contents": {
          "en":
              "${topUserModel.nameSurname}, uygulamamızdan kazandığınız ${topUserModel.money} ₺ ${topUserModel.bankName} hesabınıza yatırılmıştır.",
        },
      },
    );
  }
}
