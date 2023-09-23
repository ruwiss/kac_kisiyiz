import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/http_service.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/models/user_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/services/providers/settings_provider.dart';
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
        homeProvider.setCategorySurveys(items);
      } else {
        homeProvider.setSurveys(items);
      }
    }
  }

  Future<bool> _addAmountDatabase({required double amount}) async {
    final response = await httpService.request(
        url: KStrings.patchMoney,
        method: HttpMethod.patch,
        data: {"moneyAmount": amount});
    return response != null && response.statusCode == 200;
  }

  Future voteSurvey(
      {required SurveyModel surveyModel, required SurveyChoices choice}) async {
    final homeProvier = locator.get<HomeProvider>();
    final userModel = locator.get<AuthService>().resultData.user;

    final response = await httpService.request(
        url: KStrings.patchSurvey,
        method: HttpMethod.patch,
        data: {"id": surveyModel.id, "vote": choice.name});

    if (response != null && response.statusCode == 200) {
      userModel!.voteCount++;
      if (surveyModel.isRewarded != null && surveyModel.isRewarded! > 0) {
        userModel.money += surveyModel.isRewarded!;
        await _addAmountDatabase(amount: surveyModel.isRewarded!);
      }
      homeProvier.voteSurvey(surveyModel, choice);
    }
  }

  Future postSurvey(
    BuildContext context, {
    required int? categoryId,
    required String title,
    required String content,
  }) async {
    final Utils utils = locator.get<Utils>();
    showInfo(String msg) => utils.showInfo(context, message: msg);
    stopLoding() => utils.stopLoading(context);
    final navigator = Navigator.of(context);

    FocusScope.of(context).unfocus();

    utils.startLoading(context);

    final response = await httpService.request(
        url: KStrings.postSurvey,
        method: HttpMethod.post,
        data: {
          "categoryId": categoryId,
          "title": title,
          "content": content,
          "isPending": true
        });
    if (response != null && response.statusCode == 200) {
      showInfo("Anketiniz inceleme için gönderildi.");
      navigator.pop();
    }
    stopLoding();
  }

  Future editBankAccount(
    BuildContext context, {
    required String nameSurname,
    required String bankName,
    required String iban,
  }) async {
    final Utils utils = locator.get<Utils>();

    showInfo(String msg) => utils.showInfo(context, message: msg);
    stopLoding() => utils.stopLoading(context);
    final navigator = Navigator.of(context);

    FocusScope.of(context).unfocus();

    utils.startLoading(context);

    final response = await httpService.request(
        url: KStrings.bankAccount,
        method: HttpMethod.post,
        data: {"nameSurname": nameSurname, "bankName": bankName, "iban": iban});

    if (response != null && response.statusCode == 200) {
      final settingsProvider = locator.get<SettingsProvider>();
      settingsProvider.setUserBank(UserBankModel(nameSurname, bankName, iban));
      navigator.pop();
      showInfo(response.data['msg']);
    }
    stopLoding();
  }

  Future getBankAccount() async {
    final settingsProvider = locator.get<SettingsProvider>();

    if (settingsProvider.userBank == null) {
      final response = await httpService.request(
          url: KStrings.bankAccount, method: HttpMethod.get);
      if (response != null && response.statusCode == 200) {
        if ((response.data as Map).isNotEmpty) {
          settingsProvider.setUserBank(UserBankModel.fromJson(response.data));
        }
      }
    }
  }
}
