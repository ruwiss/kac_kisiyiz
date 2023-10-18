import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kackisiyiz_panel/core/app/locator.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';
import 'package:kackisiyiz_panel/login/login_view_model.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  _navigation(BuildContext context, String name) {
    if (locator<LoginViewModel>().userToken != null) {
      context.pushReplacementNamed(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = MediaQuery.of(context).size.width < 500;
    return Container(
      padding: EdgeInsets.all(isAndroid ? 5 : 20),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: context.secondaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomMenuItem(context, page: 'add', text: 'Ekle', icon: Icons.article),
          _bottomMenuItem(context, page: 'surveys', text: 'Anketler', icon: Icons.article_outlined),
          _bottomMenuItem(context, page: 'categories', text: 'Kategoriler', icon: Icons.menu),
          _bottomMenuItem(context, page: 'payments', text: 'Ödemeler', icon: Icons.payment),
        ],
      ),
    );
  }

  TextButton _bottomMenuItem(BuildContext context, {required String page, required String text, required IconData icon}) {
    final bool isAndroid = MediaQuery.of(context).size.width < 500;
    return TextButton.icon(
      onPressed: () => _navigation(context, page),
      icon: Icon(icon, size: isAndroid ? 24 : null),
      label: Text(isAndroid ? "" : text),
    );
  }
}
