import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/http_service.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/strings.dart';
import 'package:kac_kisiyiz/widgets/global/survey_widget.dart';

class ContentService {
  final httpService = HttpService();

  Future getCategories() async {
    final homeProvider = locator.get<HomeProvider>();
    if (homeProvider.categories.isNotEmpty) return;
    homeProvider.setLoading(true);

    final response = await httpService.request(
      url: KStrings.fetchCategoriesUrl,
      method: HttpMethod.get,
    );

    if (response != null && response.statusCode == 200) {
      final items = (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      homeProvider.setCategories(items);
    }
  }

  Future getSurveys({bool voted = false, bool category = false}) async {
    final homeProvider = locator.get<HomeProvider>();

    Map<String, dynamic>? data;
    if (voted) {
      if (homeProvider.votedSurveys.isNotEmpty) return;
      homeProvider.setLoading(true);
      data = {"voted": true};
    } else if (category) {
      if (homeProvider.categorySurveys
          .containsKey(homeProvider.currentCategoryId)) return;
      homeProvider.setLoading(true);
      data = {"categoryId": homeProvider.currentCategoryId};
    } else {
      if (homeProvider.surveys.isNotEmpty) return;
      homeProvider.setLoading(true);
    }
    final response = await httpService.request(
        url: KStrings.fetchSurveys, method: HttpMethod.get, data: data);

    if (response != null && response.statusCode == 200) {
      final items =
          (response.data as List).map((e) => SurveyModel.fromJson(e)).toList();
      if (voted) {
        homeProvider.setVotedSurveys(items);
      } else if (category) {
        print(items.length);
        homeProvider.setCategorySurveys(items);
      } else {
        homeProvider.setSurveys(items);
      }
    }
  }

  Future voteSurvey(
      {required SurveyModel surveyModel, required SurveyChoices choice}) async {
    final homeProvier = locator.get<HomeProvider>();

    final response = await httpService.request(
        url: KStrings.patchSurvey,
        method: HttpMethod.patch,
        data: {"id": surveyModel.id, "vote": choice.name});

    if (response != null && response.statusCode == 200) {
      homeProvier.voteSurvey(surveyModel, choice);
    }
  }
}
