import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/auth_page/auth_page.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/http_service.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/functions/admob_ads/interstitial_ad.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/settings_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/models/user_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/strings.dart';
import 'package:kac_kisiyiz/widgets/global/survey_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentService {
  final _httpService = HttpService();
  final _dio = Dio();
  String? privacyPolicy;
  late List<SettingsModel> settings;
  int voteCounter = 0;
  final interstitialAd =
      InterstitialAdManager(adUnitId: KStrings.insertstitialId);

  Future getSettings() async {
    final response = await _httpService.request(
        url: KStrings.settings, method: HttpMethod.get);
    if (response != null && response.statusCode == 200) {
      List<SettingsModel> items = [];
      for (var i in response.data) {
        items.add(SettingsModel.fromJson(i));
      }
      settings = items;
    }
  }

  void _checkForAd(BuildContext context) {
    voteCounter++;
    final limit =
        settings.singleWhere((e) => e.name == "surveyAdDisplayCount").attr;
    if (voteCounter >= int.parse(limit)) {
      Utils.startLoading(context, text: "Reklam Bekleniyor");
      interstitialAd.load(
        onLoaded: (ad) {
          voteCounter = 0;
          Utils.stopLoading(context);
          ad.show();
        },
        onError: () {
          voteCounter--;
          Utils.stopLoading(context);
        },
      );
    }
  }

  Future getCategories() async {
    final homeProvider = locator.get<HomeProvider>();
    if (homeProvider.categories.isNotEmpty) return;
    homeProvider.setLoading(true);

    final response = await _httpService.request(
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
    final response = await _httpService.request(
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
    final response = await _httpService.request(
        url: KStrings.patchMoney,
        method: HttpMethod.patch,
        data: {"moneyAmount": amount});
    return response != null && response.statusCode == 200;
  }

  Future voteSurvey(BuildContext context,
      {required SurveyModel surveyModel, required SurveyChoices choice}) async {
    final homeProvier = locator.get<HomeProvider>();
    final userModel = locator.get<AuthService>().resultData.user;
    showConfirmDialog(Function() onConfirm) => Utils.showConfirmDialog(context,
        title: "Bilgi",
        message: "Bu konuyla ilgili bir makale var. Okumak ister misin?",
        onConfirm: onConfirm,
        buttonColor: KColors.primary);

    final response = await _httpService.request(
        url: KStrings.patchSurvey,
        method: HttpMethod.patch,
        data: {"id": surveyModel.id, "vote": choice.name});

    if (response != null && response.statusCode == 200) {
      userModel!.voteCount++;
      if (surveyModel.isRewarded != null && surveyModel.isRewarded! > 0) {
        userModel.money += surveyModel.isRewarded!;
        await _addAmountDatabase(amount: surveyModel.isRewarded!);
      }
      final adLink = surveyModel.adLink;
      if (adLink != null && adLink.isNotEmpty) {
        showConfirmDialog(() {
          launchUrl(Uri.parse(adLink), mode: LaunchMode.externalApplication);
        });
      }
      homeProvier.voteSurvey(surveyModel, choice);
      if (context.mounted) _checkForAd(context);
    }
  }

  Future postSurvey(
    BuildContext context, {
    required int? categoryId,
    required String title,
    required String content,
  }) async {
    showInfo(String msg) => Utils.showInfo(context, message: msg);
    stopLoding() => Utils.stopLoading(context);
    final navigator = Navigator.of(context);

    FocusScope.of(context).unfocus();

    Utils.startLoading(context);

    final response = await _httpService.request(
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
    showInfo(String msg) => Utils.showInfo(context, message: msg);
    stopLoding() => Utils.stopLoading(context);
    final navigator = Navigator.of(context);

    FocusScope.of(context).unfocus();

    Utils.startLoading(context);

    final response = await _httpService.request(
        url: KStrings.bankAccount,
        method: HttpMethod.post,
        data: {"nameSurname": nameSurname, "bankName": bankName, "iban": iban});

    if (response != null && response.statusCode == 200) {
      final authResponse = locator.get<AuthService>().resultData;
      final myDB = locator.get<MyDB>();

      authResponse.user!.bankAccount =
          UserBankModel(nameSurname, bankName, iban);
      myDB.saveUser(authResponse);
      navigator.pop();
      showInfo(response.data['msg']);
    }
    stopLoding();
  }

  Future getBankAccount() async {
    final authResponse = locator.get<AuthService>().resultData;
    final myDB = locator.get<MyDB>();

    if (authResponse.user!.bankAccount == null) {
      final response = await _httpService.request(
          url: KStrings.bankAccount, method: HttpMethod.get);
      if (response != null && response.statusCode == 200) {
        if ((response.data as Map).isNotEmpty) {
          authResponse.user!.bankAccount =
              UserBankModel.fromJson(response.data);
          myDB.saveUser(authResponse);
        }
      }
    }
  }

  Future deleteBankAccount(BuildContext context) async {
    final authResponse = locator.get<AuthService>().resultData;
    final myDB = locator.get<MyDB>();
    showInfo(String msg) => Utils.showInfo(context, message: msg);

    final navigator = Navigator.of(context);

    final response = await _httpService.request(
        url: KStrings.bankAccount, method: HttpMethod.delete);

    if (response != null && response.statusCode == 200) {
      authResponse.user!.bankAccount = null;
      myDB.saveUser(authResponse);
      navigator.pop();
      showInfo(response.data['msg']);
    }
  }

  Future<String?> getPrivacyPolicy() async {
    if (privacyPolicy != null) {
      return privacyPolicy!;
    }
    final response = await _dio.get(KStrings.privacyPolicy,
        options: Options(responseType: ResponseType.plain));
    if (response.statusCode == 200) {
      String data = response.data;
      if (data.contains("<!-- 1 -->")) {
        data = data.split("<!-- 1 -->")[1].split("<!-- 2 -->")[0].trim();
      }
      privacyPolicy = data;
      return data;
    }
    return null;
  }

  Future deleteUserAccount(BuildContext context) async {
    final navigator = Navigator.of(context);
    final response = await _httpService.request(
        url: KStrings.deleteUser, method: HttpMethod.delete);
    if (response != null && response.statusCode == 200) {
      final homeProvider = locator.get<HomeProvider>();

      homeProvider.resetData();

      locator.unregister<AuthService>();
      locator.unregister<ContentService>();
  
      locator.registerSingleton<AuthService>(AuthService());
      locator.registerSingleton<ContentService>(ContentService());

      locator.get<MyDB>().deleteUser();
      OneSignal.logout();
      navigator.pop();
      navigator.pushNamedAndRemoveUntil("/", (route) => route is AuthPage);
    }
  }

  Future changeUserInformation(BuildContext context, Map<String, dynamic> data,
      {Function(String)? onError}) async {
    if (data.isEmpty) return;
    final navigator = Navigator.of(context);
    final authResponse = locator.get<AuthService>().resultData;
    final myDB = locator.get<MyDB>();

    final response = await _httpService.request(
      url: KStrings.patchUserInformation,
      method: HttpMethod.patch,
      data: data,
    );

    if (response != null && response.statusCode == 200) {
      data.forEach((key, value) {
        if (key == "name") {
          authResponse.user!.name = data["name"];
        } else if (key == "newPassword") {
          authResponse.user!.password = data["newPassword"];
        }
      });
      myDB.saveUser(authResponse);
      navigator.pop();
      if (data.containsKey("newPassword") && context.mounted) {
        locator.get<AuthService>().signOut(context);
      }
      if (context.mounted) {
        Utils.showInfo(context, message: response.data["msg"]);
      }
    } else if (response != null && response.statusCode == 401) {
      if (onError != null) onError(response.data["msg"]);
    }
  }
}
