import 'package:dio/dio.dart';
import '../constants/hosts.dart';
import '../constants/strings.dart';
import 'dart:developer';

class SendNotification {
  static Future<void> toUser(
      {required String? user,
      required String heading,
      required String content}) async {
    final dio = Dio();
    if (user == null) {
      log("User is null");
      return;
    }
    final status = await dio.post(
      KHost.onesignalRestApi,
      options:
          Options(headers: {'Content-Type': 'application/json; charset=UTF-8'}),
      data: {
        "app_id": KStrings.onesignalAppId,
        "include_subscription_ids": [user],
        "headings": {"en": heading},
        "contents": {"en": content},
      },
    );

    log("${status.statusCode}: ${status.data}");
  }
}
