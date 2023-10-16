import 'package:get_it/get_it.dart';
import 'package:kackisiyiz_panel/add_survey/add_survey_view_model.dart';
import 'package:kackisiyiz_panel/categories/categories_view_model.dart';
import 'package:kackisiyiz_panel/core/services/http_service.dart';
import 'package:kackisiyiz_panel/login/login_view_model.dart';
import 'package:kackisiyiz_panel/payments/payments_view_model.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view_model.dart';

final locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => HttpService());

  locator.registerSingleton<LoginViewModel>(LoginViewModel());
  locator.registerSingleton<AddSurveyViewModel>(AddSurveyViewModel());
  locator.registerSingleton<SurveysViewModel>(SurveysViewModel());
  locator.registerSingleton<CategoriesViewModel>(CategoriesViewModel());
  locator.registerSingleton<PaymentsViewModel>(PaymentsViewModel());
}
