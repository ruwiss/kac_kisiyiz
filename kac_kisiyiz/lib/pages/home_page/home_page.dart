import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/categories_tab.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile/profile_tab.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/backend/onesignal_api.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/services/extensions/string_extensions.dart';
import 'package:kac_kisiyiz/services/functions/admob_ads/app_lifecycle_reactor.dart';
import 'package:kac_kisiyiz/services/functions/admob_ads/app_open_ad.dart';
import 'package:kac_kisiyiz/services/functions/admob_ads/interstitial_ad.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/images.dart';
import 'package:kac_kisiyiz/utils/strings.dart';
import 'package:kac_kisiyiz/widgets/features/home/filter_button.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/bottom_menu.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_container.dart';
import 'package:kac_kisiyiz/widgets/global/shimmer_survey_widget.dart';
import 'package:kac_kisiyiz/widgets/global/survey_widget.dart';
import 'package:kac_kisiyiz/widgets/global/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Filters _currentFilter = Filters.yeniler;

  void _setCurrentFilter(Filters filter) {
    setState(() => _currentFilter = filter);
    if (filter == Filters.katilimlar) {
      locator.get<ContentService>().getSurveys(voted: true);
    }
    if (filter != Filters.category) {
      locator.get<HomeProvider>().setCurrentCategoryId(-1);
    }
  }

  void _setAdmobAds() {
    // AppOpen
    AppOpenAdManager appOpenAdManager = AppOpenAdManager(adUnitId: KStrings.appOpenId)..loadAd();
    AppLifecycleReactor(appOpenAdManager: appOpenAdManager).listenToAppStateChanges();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // appOpenAd Permission
      final bool appOpenAd = locator<ContentService>().settings.singleWhere((e) => e.name == "appOpenAd").name.parseStringBool();
      if (appOpenAd) {
        Utils.startLoading(context, text: "Hoşgeldiniz");
        // Interstitial
        final interstitialAdManager = InterstitialAdManager(adUnitId: KStrings.insertstitialId);
        interstitialAdManager.load(
          onLoaded: (ad) {
            Utils.stopLoading(context);
            ad.show();
          },
          onError: () => Utils.stopLoading(context),
        );
      }
    });
  }

  Future _getDatas() async {
    final contentService = locator.get<ContentService>();
    await contentService.getSettings();
    await contentService.getSurveys();
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    _getDatas().then((_) => _setAdmobAds());
    OneSignalApi.setupOneSignal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<HomeProvider>(
              builder: (context, value, child) => Column(
                children: [
                  if (value.surveyLoading) const LinearProgressIndicator(color: KColors.primary),
                  Expanded(
                    child: switch (value.currentMenu) {
                      (MenuItems.kackisiyiz) => _kacKisiyizTab(value),
                      (MenuItems.kategoriler) => const CategoriesTab(),
                      (_) => const ProfileTab()
                    },
                  ),
                ],
              ),
            ),
            Positioned(bottom: 10, right: 33, left: 33, child: BottomMenu())
          ],
        ),
      ),
    );
  }

  Widget _kacKisiyizTab(HomeProvider provider) {
    if (provider.currentCategoryId != -1) _currentFilter = Filters.category;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: TitleWidget.medium(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterButton(
              text: "Yeniler",
              filter: Filters.yeniler,
              currentFilter: _currentFilter,
              onTap: _setCurrentFilter,
            ),
            _currentFilter != Filters.category
                ? FilterButton(
                    text: "Katılımlar",
                    filter: Filters.katilimlar,
                    currentFilter: _currentFilter,
                    onTap: _setCurrentFilter,
                  )
                : FilterButton(
                    text: provider.getCategoryFromId(provider.currentCategoryId).category,
                    filter: Filters.category,
                    currentFilter: _currentFilter,
                    onTap: _setCurrentFilter,
                  )
          ],
        ),
        const SizedBox(height: 15),
        Consumer<HomeProvider>(
          builder: (context, value, child) {
            final bool isCategory = value.currentCategoryId != -1;
            CategoryModel? category;
            if (isCategory) category = value.getCategoryFromId(value.currentCategoryId);

            final List<SurveyModel> items = switch (_currentFilter) {
              Filters.yeniler => value.surveys,
              Filters.katilimlar => value.votedSurveys,
              Filters.category => value.categorySurveys[value.currentCategoryId] ?? []
            };
            return Container(
              child: _currentFilter != Filters.katilimlar
                  ? Expanded(
                      child: Swiper(
                        itemCount: items.length + 1,
                        scrollDirection: Axis.vertical,
                        loop: false,
                        physics: const BouncingScrollPhysics(),
                        scale: 0.9,
                        itemBuilder: (context, index) => value.surveyLoading
                            ? const ShimmerSurveyWidget()
                            : items.isEmpty
                                ? _noSurveyFoundWidget(isCategory, category)
                                : index != items.length
                                    ? SurveyWidget(
                                        small: _currentFilter == Filters.katilimlar,
                                        surveyModel: items[index],
                                      )
                                    : _infoWidget("Bu günlük daha fazla ankete katılamazsınız."),
                      ),
                    )
                  : Expanded(
                      child: value.surveyLoading
                          ? const ShimmerSurveyWidget(small: true)
                          : items.isEmpty
                              ? _infoWidget("Henüz bir ankete katılmadınız.")
                              : ListView.builder(
                                  itemCount: items.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => Container(
                                    height: 300,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: SurveyWidget(
                                      small: _currentFilter == Filters.katilimlar,
                                      surveyModel: items[index],
                                    ),
                                  ),
                                ),
                    ),
            );
          },
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Padding _noSurveyFoundWidget(bool isCategory, CategoryModel? category) {
    final myDB = locator<MyDB>();
    final bool isVoted = myDB.homePageAppVoteButtonClicked();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isCategory ? Icon(IconData(category!.iconPoint!, fontFamily: "MaterialIcons"), color: KColors.primary.withOpacity(.8), size: 50) : Image.asset(KImages.cafee, width: 65),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              isCategory ? category!.category : "Daha Fazla Anket?",
              style: const TextStyle(fontSize: 15, color: KColors.primary, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            isCategory ? "Bu kategoride şuanlık anket bulunmuyor veya günlük limite ulaştınız.\n\n\nUygulamaya yeni anketler gelmeye devam edecektir. Dilerseniz profilim menüsünden anket gönderebilir ve destek olabilirsiniz." : "Görünüşe göre günlük anket çözme sınırına ulaşmışsın.\n\n\nYarın tekrardan gelip yeni anketlere katılabilirsin.",
            textAlign: TextAlign.center,
          ),
          if (!isVoted && !isCategory) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                "Ayrıca, eğer uygulamayı beğendiysen güzel bir yorum bırakabilir misin?",
                textAlign: TextAlign.center,
              ),
            ),
            ActionButton(
              text: "Uygulamayı Oyla",
              textStyle: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              onPressed: () {
                myDB.setHomePageAppVoteButtonClicked();
                launchUrl(Uri.parse(KStrings.appUrl), mode: LaunchMode.externalApplication);
              },
            )
          ]
        ],
      ),
    );
  }

  Container _infoWidget(String text) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(KImages.profilePattern),
          opacity: .1,
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 65),
        child: InputContainer(
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
