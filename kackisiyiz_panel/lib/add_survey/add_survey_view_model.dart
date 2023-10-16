import 'package:kackisiyiz_panel/add_survey/common/add_survey_api_service.dart';
import 'package:kackisiyiz_panel/add_survey/common/models/category_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view_model.dart';
import 'common/models/add_survey_model.dart';

class AddSurveyViewModel extends BaseViewModel {
  final _addSurveyApiService = AddSurveyApiService();
  CategoryModel? selectedCategory;
  List<CategoryModel>? categories;

  setSelectedCategory(int? id) {
    if (id == null) {
      selectedCategory = null;
      notifyListeners();
    }
    final selectedIndex = categories?.indexWhere((e) => e.id == id);
    if (selectedIndex == -1 || categories == null) return;
    selectedCategory = categories![selectedIndex!];
    notifyListeners();
  }

  Future getCategories() async {
    if (categories != null) return;
    setState(ViewState.busy);
    categories = await _addSurveyApiService.getCategories();
    setState(ViewState.idle);
  }

  Future<bool> addSurvey(AddSurveyModel addSurveyModel) async {
    setState(ViewState.busy);
    final status = await _addSurveyApiService.patchSurvey(addSurveyModel);
    if (status) {
      setInfoText("Kaydedildi");
    } else {
      setInfoText("Bir sorun oluştu");
    }
    setState(ViewState.idle);
    return status;
  }
}
