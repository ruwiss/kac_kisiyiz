import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/http_service.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/strings.dart';

class ContentService {
  final httpService = HttpService();

  Future getCategories() async {
    final homeProvider = locator.get<HomeProvider>();
    if (homeProvider.categories.isNotEmpty) return;

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

  Future getSurveys({bool voted = false}) async {
    final homeProvider = locator.get<HomeProvider>();
    Map<String, dynamic>? data;
    if (voted) {
      if (homeProvider.votedSurveys.isNotEmpty) return;
      data = {"voted": true};
    } else {
      if (homeProvider.surveys.isNotEmpty) return;
    }
    final response = await httpService.request(
        url: KStrings.fetchSurveys, method: HttpMethod.get, data: data);

    if (response != null && response.statusCode == 200) {
      final items =
          (response.data as List).map((e) => SurveyModel.fromJson(e)).toList();
      if (voted) {
        homeProvider.setVotedSurveys(items);
      } else {
        homeProvider.setSurveys(items);
      }
    }
  }
}
