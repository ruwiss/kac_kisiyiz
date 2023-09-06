import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatelessWidget {
  BottomMenu({super.key});

  final Map<MenuItems, List> _menuItemsMap = {
    MenuItems.kackisiyiz: ["Kaç Kişiyiz?", Icons.home],
    MenuItems.kategoriler: ["Kategoriler", Icons.stacked_bar_chart],
    MenuItems.profilim: ["Profilim", Icons.tag_faces_sharp],
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        side: BorderSide(color: KColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _menuItem(context, MenuItems.kackisiyiz),
          _menuItem(context, MenuItems.kategoriler),
          _menuItem(context, MenuItems.profilim),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, MenuItems menuItem) {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    final bool isCurrent = homeProvider.currentMenu == menuItem;
    return InkWell(
      onTap: () => homeProvider.setCurrentMenu(menuItem),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Column(
          children: [
            Icon(
              _menuItemsMap[menuItem]![1],
              color: isCurrent ? KColors.bottomMenuIcon : KColors.disabled,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              _menuItemsMap[menuItem]![0],
              style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.bold : null,
                  color: Colors.black.withOpacity(.8),
                  fontSize: 13.5),
            )
          ],
        ),
      ),
    );
  }
}
