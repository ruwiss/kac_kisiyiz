import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:provider/provider.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  @override
  void initState() {
    locator.get<ContentService>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 30),
          child: Text(
            "Kategoriler",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Consumer<HomeProvider>(
                builder: (context, value, child) => GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 0.5,
                    mainAxisSpacing: 35,
                  ),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: value.categories
                      .map(
                        (e) => InkWell(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          splashColor: KColors.primary.withOpacity(0.1),
                          onTap: () {
                            value.setCurrentCategoryId(e.id!);
                            value.setCurrentMenu(MenuItems.kackisiyiz);
                            locator
                                .get<ContentService>()
                                .getSurveys(category: true);
                          },
                          child: Column(
                            children: [
                              Icon(
                                IconData(e.iconPoint,
                                    fontFamily: "MaterialIcons"),
                                size: 50,
                                color: Colors.black.withOpacity(0.65),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                e.category,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )),
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}
