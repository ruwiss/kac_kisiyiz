import 'package:flutter/material.dart';

enum MenuItems { kackisiyiz, kategoriler, profilim }

class HomeProvider with ChangeNotifier {
  MenuItems currentMenu = MenuItems.kackisiyiz;

  void setCurrentMenu(MenuItems item) {
    currentMenu = item;
    notifyListeners();
  }
}
