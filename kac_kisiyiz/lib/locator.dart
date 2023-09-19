import 'package:get_it/get_it.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Utils>(Utils());
  locator.registerSingleton<HomeProvider>(HomeProvider());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<ContentService>(ContentService());
}
