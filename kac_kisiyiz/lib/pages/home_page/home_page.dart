import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/categories_tab.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile_tab.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/widgets/features/home/filter_button.dart';
import 'package:kac_kisiyiz/widgets/global/bottom_menu.dart';
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

  void _setCurrentFilter(Filters filter) =>
      setState(() => _currentFilter = filter);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<HomeProvider>(
              builder: (context, value, child) => switch (value.currentMenu) {
                (MenuItems.kackisiyiz) => _kacKisiyizTab(),
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

  Widget _kacKisiyizTab() {
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
              filter: Filters.yeniler,
              currentFilter: _currentFilter,
              onTap: _setCurrentFilter,
            ),
            FilterButton(
              filter: Filters.katilimlar,
              currentFilter: _currentFilter,
              onTap: _setCurrentFilter,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          flex: _currentFilter == Filters.yeniler ? 1 : 0,
          child: SurveyWidget(
            small: _currentFilter == Filters.katilimlar,
            surveyModel: SurveyModel(
              id: 0,
              category: "Sağlık",
              categoryId: "saglik",
              userId: "123",
              userName: "Ömer G",
              title:
                  'Kilo vermek için "Onu içmek zayıflatır, bunu hiç yememelisiniz!" gibi önerileri deneyip patlayan',
              content:
                  'Ara ara çıkan "Bunu böyle içmek zayıflatır; şunu şu zamanda şöyle yerseniz kilo vermenizi sağlar" gibi önerileri deneyip de sonuç almayanlarınız var mı? Bu konuda doğru olmayan, kısmen doğru olsa bile herkese yaramayan o kadar çok öneri var ki!',
              imageUrl:
                  "https://cdn.bhdw.net/im/anime-food-market-wallpaper-76982_w635.webp",
              choice1: 56,
              choice2: 289,
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
