import 'package:get_it/get_it.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<HomeProvider>(HomeProvider());
}
