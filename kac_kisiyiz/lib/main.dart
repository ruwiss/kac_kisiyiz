import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/auth_page/auth_page.dart';
import 'package:kac_kisiyiz/pages/auth_page/forgot_password.dart';
import 'package:kac_kisiyiz/pages/home_page/home_page.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/providers/auth_provider.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  setupLocator();
  await locator.get<MyDB>().initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => locator.get<AuthProvider>()),
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => locator.get<HomeProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
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
          "/forgotPassword": (context) => const ForgotPasswordPage()
        },
      ),
    );
  }
}
