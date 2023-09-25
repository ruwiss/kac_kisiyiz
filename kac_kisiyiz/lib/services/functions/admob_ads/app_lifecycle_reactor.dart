import 'dart:developer';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kac_kisiyiz/services/functions/admob_ads/app_open_ad.dart';

class AppLifecycleReactor {
  AppLifecycleReactor({required this.appOpenAdManager});
  final AppOpenAdManager appOpenAdManager;

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    log("App State Changed: ${appState.name}");
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
