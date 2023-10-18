import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/app/locator.dart';
import 'package:kackisiyiz_panel/core/app/router.dart';
import 'package:kackisiyiz_panel/add_survey/add_survey_view_model.dart';
import 'package:kackisiyiz_panel/login/login_view_model.dart';
import 'package:kackisiyiz_panel/payments/payments_view_model.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view_model.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'categories/categories_view_model.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => locator<LoginViewModel>()),
        ChangeNotifierProvider(create: (context) => locator<AddSurveyViewModel>()),
        ChangeNotifierProvider(create: (context) => locator<SurveysViewModel>()),
        ChangeNotifierProvider(create: (context) => locator<CategoriesViewModel>()),
        ChangeNotifierProvider(create: (context) => locator<PaymentsViewModel>()),
      ],
      child: YaruTheme(
        builder: (context, yaru, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Kaç Kişiyiz? | Panel',
            theme: yaru.theme,
            darkTheme: yaru.darkTheme,
            //darkTheme: context.themeData(),
            themeMode: ThemeMode.dark,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
