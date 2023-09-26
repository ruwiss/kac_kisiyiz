import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/utils/strings.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalApi {
  static Future setupOneSignal() async {
    final user = locator.get<AuthService>().resultData.user!;
    OneSignal.initialize(KStrings.oneSignalAppId);
    await OneSignal.Notifications.requestPermission(true);

    await OneSignal.login(user.id.toString());
    await OneSignal.User.addEmail(user.mail);
  }
}
