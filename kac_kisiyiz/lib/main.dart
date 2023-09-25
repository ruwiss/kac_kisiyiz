import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/auth_page.dart';
import 'package:kac_kisiyiz/pages/home_page/home_page.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/services/providers/settings_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  /* SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark)); */
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  MobileAds.instance.initialize();
  await locator.get<MyDB>().initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => locator.get<HomeProvider>()),
        ChangeNotifierProvider<SettingsProvider>(
            create: (context) => locator.get<SettingsProvider>())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const AuthPage(),
        "/home": (context) => const HomePage(),
      },
    );
  }
}
