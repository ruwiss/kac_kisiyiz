import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/categories_tab.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile/profile_tab.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/images.dart';
import 'package:kac_kisiyiz/widgets/features/home/filter_button.dart';
import 'package:kac_kisiyiz/widgets/global/bottom_menu.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_container.dart';
import 'package:kac_kisiyiz/widgets/global/survey_widget.dart';
import 'package:kac_kisiyiz/widgets/global/title_widget.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    locator.get<ContentService>().getSurveys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<HomeProvider>(
              builder: (context, value, child) => switch (value.currentMenu) {
                (MenuItems.kackisiyiz) => _kacKisiyizTab(value),
                (MenuItems.kategoriler) => const CategoriesTab(),
                (_) => const ProfileTab()
              },
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
                    text: provider
                        .getCategoryFromId(provider.currentCategoryId)
                        .category,
                    filter: Filters.category,
                    currentFilter: _currentFilter,
                    onTap: _setCurrentFilter,
                  )
          ],
        ),
        const SizedBox(height: 15),
        Consumer<HomeProvider>(
          builder: (context, value, child) => Container(
            child: _currentFilter != Filters.katilimlar
                ? Expanded(
                    child: Swiper(
                      itemCount: value.surveys.length + 1,
                      scrollDirection: Axis.vertical,
                      loop: false,
                      physics: const BouncingScrollPhysics(),
                      scale: 0.9,
                      itemBuilder: (context, index) => index !=
                              value.surveys.length
                          ? SurveyWidget(
                              small: _currentFilter == Filters.katilimlar,
                              surveyModel: value.surveys[index],
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(KImages.profilePattern),
                                  opacity: .1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 65),
                                child: InputContainer(
                                  child: Text(
                                    "Bu günlük daha fazla ankete katılamazsınız.",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: value.votedSurveys.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        height: 330,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SurveyWidget(
                          small: _currentFilter == Filters.katilimlar,
                          surveyModel: value.votedSurveys[index],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
