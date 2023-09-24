import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/widgets/global/survey_widget.dart';

enum MenuItems { kackisiyiz, kategoriler, profilim }

class HomeProvider with ChangeNotifier {
  MenuItems currentMenu = MenuItems.kackisiyiz;
  List<CategoryModel> categories = [];
  int currentCategoryId = -1;

  List<SurveyModel> surveys = [];
  List<SurveyModel> votedSurveys = [];
  Map<int, List<SurveyModel>> categorySurveys = {};

  bool surveyLoading = false;

  void setLoading(bool v) {
    surveyLoading = v;
  }

  void setCurrentMenu(MenuItems item) {
    currentMenu = item;
    notifyListeners();
  }

  void setCategories(List<CategoryModel> items) {
    categories = items;
    setLoading(false);
    notifyListeners();
  }

  CategoryModel getCategoryFromId(int id) {
    return categories.singleWhere((element) => element.id == id);
  }

  void setCurrentCategoryId(int id) {
    currentCategoryId = id;
    notifyListeners();
  }

  void setSurveys(List<SurveyModel> list) {
    surveys = list;
    setLoading(false);
    notifyListeners();
  }

  void setVotedSurveys(List<SurveyModel> list) {
    votedSurveys = list;
    setLoading(false);
    notifyListeners();
  }

  void setCategorySurveys(List<SurveyModel> list) {
    categorySurveys[currentCategoryId] = list;
    setLoading(false);
    notifyListeners();
  }

  void voteSurvey(SurveyModel surveyModel, SurveyChoices choice) {
    if (choice == SurveyChoices.ch1) surveyModel.choice1++;
    if (choice == SurveyChoices.ch2) surveyModel.choice2++;

    votedSurveys.add(surveyModel);

    if (categorySurveys.containsKey(surveyModel.id)) {
      categorySurveys.remove(surveyModel.id);
    }

    notifyListeners();
  }

  bool isVotedSurvey(int id) {
    return votedSurveys.indexWhere((element) => element.id == id) != -1;
  }

  void resetData() {
    currentMenu = MenuItems.kackisiyiz;
    categories = [];
    currentCategoryId = -1;
    surveys = [];
    votedSurveys = [];
    categorySurveys = {};
    notifyListeners();
  }
}
