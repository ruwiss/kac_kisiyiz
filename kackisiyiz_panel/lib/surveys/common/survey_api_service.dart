import 'package:kackisiyiz_panel/core/services/http_service.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view.dart';
import '../../core/app/locator.dart';
import '../../core/constants/hosts.dart';
import '../../core/models/survey_model.dart';

class SurveyApiService {
  final _http = locator<HttpService>();

  Future<bool> deleteSurvey(int id) async {
    final response = await _http.request(url: KHost.surveyData, method: HttpMethod.delete, withToken: true, data: {
      "id": id
    });
    return response?.statusCode == 200;
  }

  Future<List<SurveyModel>?> getSurveys({String? searchText, required SelectedFilter selectedFilter}) async {
    Map<String, dynamic> data = {
      "forPanel": true,
      "filter": selectedFilter.name,
    };
    if (searchText != null) data["search"] = searchText;
    final response = await _http.request(url: KHost.surveys, method: HttpMethod.get, data: data, withToken: true);
    if (response == null) return null;
    List<SurveyModel> surveys = [];
    for (var i in response.data) {
      surveys.add(SurveyModel.fromJson(i));
    }
    return surveys;
  }
}
