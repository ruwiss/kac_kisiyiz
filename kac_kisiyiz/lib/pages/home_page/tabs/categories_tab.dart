import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {

  late List<CategoryModel> _categories;

  @override
  void initState() {
    _categories = List.generate(
        20, (index) => CategoryModel.fromList(["Sağlık", 0xed36]));
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
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / .5,
                  mainAxisSpacing: 35),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: _categories
                  .map(
                    (e) => InkWell(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      splashColor: KColors.primary.withOpacity(.1),
                      onTap: () {},
                      child: Column(
                        children: [
                          Icon(
                            IconData(e.iconPoint, fontFamily: "MaterialIcons"),
                            size: 50,
                            color: Colors.black.withOpacity(.65),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            e.category,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black.withOpacity(.8)),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}