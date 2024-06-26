import 'package:get_it/get_it.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/providers/auth_provider.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AuthProvider>(AuthProvider());
  locator.registerSingleton<HomeProvider>(HomeProvider());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<ContentService>(ContentService());
  locator.registerSingleton<MyDB>(MyDB());
}
