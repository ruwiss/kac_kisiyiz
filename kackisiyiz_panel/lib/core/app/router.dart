import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kackisiyiz_panel/core/app/locator.dart';
import 'package:kackisiyiz_panel/core/models/survey_model.dart';
import 'package:kackisiyiz_panel/login/login_view_model.dart';
import 'package:kackisiyiz_panel/add_survey/add_survey_view.dart';
import 'package:kackisiyiz_panel/categories/categories_view.dart';
import 'package:kackisiyiz_panel/login/login_view.dart';
import 'package:kackisiyiz_panel/payments/payments_view.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view.dart';

GoRoute transitionGoRoute({
  required String path,
  required String name,
  required Widget Function(BuildContext context, GoRouterState state)
      pageBuilder,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 300),
      child: pageBuilder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        );
      },
    ),
  );
}

final GoRouter router = GoRouter(
  initialLocation: "/login",
  routes: [
    transitionGoRoute(
        path: "/login",
        name: "login",
        pageBuilder: (context, state) => LoginView()),
    transitionGoRoute(
        path: "/addSurvey",
        name: "add",
        pageBuilder: (context, state) {
          final args = state.uri.queryParameters;
          SurveyModel? surveyModel;
          if (args.isNotEmpty) surveyModel = SurveyModel.fromJsonString(args);

          return AddSurveyView(surveyModel: surveyModel);
        }),
    transitionGoRoute(
        path: "/surveys",
        name: "surveys",
        pageBuilder: (context, state) => SurveysView()),
    transitionGoRoute(
        path: "/categories",
        name: "categories",
        pageBuilder: (context, state) => const CategoriesView()),
    transitionGoRoute(
        path: "/payments",
        name: "payments",
        pageBuilder: (context, state) => const PaymentsView()),
  ],
  redirect: (context, state) {
    if (locator<LoginViewModel>().userToken == null) {
      return '/login';
    }
    return null;
  },
);
