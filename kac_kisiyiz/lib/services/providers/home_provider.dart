import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';

enum MenuItems { kackisiyiz, kategoriler, profilim }

class HomeProvider with ChangeNotifier {
  MenuItems currentMenu = MenuItems.kackisiyiz;
  List<CategoryModel> categories = [];
  int currentCategoryId = -1;

  List<SurveyModel> surveys = [];
  List<SurveyModel> votedSurveys = [];

  void setCurrentMenu(MenuItems item) {
    currentMenu = item;
    notifyListeners();
  }

  void setCategories(List<CategoryModel> items) {
    categories = items;
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
    notifyListeners();
  }

  void setVotedSurveys(List<SurveyModel> list) {
    votedSurveys = list;
    notifyListeners();
  }
}
