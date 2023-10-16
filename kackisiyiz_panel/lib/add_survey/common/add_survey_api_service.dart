import 'package:kackisiyiz_panel/core/app/locator.dart';
import 'package:kackisiyiz_panel/core/services/category_api_service.dart';
import '../../core/constants/hosts.dart';
import '../../core/services/http_service.dart';
import 'models/add_survey_model.dart';

class AddSurveyApiService extends CategoryApiService{
  final _http = locator<HttpService>();

  Future<bool> patchSurvey(AddSurveyModel addSurveyModel) async {
    final bool isUpdate = addSurveyModel.id != null;
    final response = await _http.request(
      url: isUpdate ? KHost.editSurvey : KHost.surveyData,
      method: isUpdate ? HttpMethod.patch : HttpMethod.post,
      withToken: true,
      data: addSurveyModel.toJson(),
    );
    return response?.statusCode == 200;
  }
}
