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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: context.secondaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () => _navigation(context, 'add'),
            icon: const Icon(Icons.article),
            label: const Text('Ekle'),
          ),
          TextButton.icon(
            onPressed: () => _navigation(context, 'surveys'),
            icon: const Icon(Icons.article_outlined),
            label: const Text('Eklenenler'),
          ),
          TextButton.icon(
            onPressed: () =>  _navigation(context, 'categories'),
            icon: const Icon(Icons.menu),
            label: const Text('Kategori'),
          ),
          TextButton.icon(
            onPressed: () => _navigation(context, 'payments'),
            icon: const Icon(Icons.payment),
            label: const Text('Ödemeler'),
          ),
        ],
      ),
    );
  }
}
