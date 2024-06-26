import 'package:kackisiyiz_panel/core/models/survey_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view_model.dart';
import 'package:kackisiyiz_panel/surveys/common/survey_api_service.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view.dart';

class SurveysViewModel extends BaseViewModel {
  final _apiService = SurveyApiService();
  List<SurveyModel>? surveys;

  Future getSurveys({String? searchText, required SelectedFilter selectedFilter}) async {
    setState(ViewState.busy);
    surveys = await _apiService.getSurveys(searchText: searchText, selectedFilter: selectedFilter);
    setState(ViewState.idle);
  }

  Future<bool> deleteSurvey(int id) async {
    setState(ViewState.busy);
    final status = await _apiService.deleteSurvey(id);
    if (status) surveys?.removeWhere((e) => e.id == id);
    setState(ViewState.idle);
    return status;
  }
}
