import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/models/category_model.dart';
import 'package:kackisiyiz_panel/categories/categories_view_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view.dart';
import 'package:kackisiyiz_panel/categories/common/widgets/category_widget.dart';
import '../core/app/base_view_model.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoriesViewModel>(
      onModelReady: (model) => model.getCategories(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            body: model.state == ViewState.busy
                ? const Center(child: Text("Bekleyiniz.."))
                : model.categories == null
                    ? const Text("Bir sorun oluştu")
                    : Column(
                        children: [
                          _listWidget(model),
                        ],
                      ),
          ),
        );
      },
    );
  }

  Flexible _listWidget(CategoriesViewModel model) {
    return Flexible(
      child: ListView.separated(
        itemCount: model.categories!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final categoryModel = model.categories![index];
          return Column(
            children: [
              if (index == 0)
                CategoryWidget(
                  categoryModel: CategoryModel.empty(),
                  onChanged: model.patchCategory,
                  onDeleted: model.deleteCategory,
                ),
              CategoryWidget(
                categoryModel: categoryModel,
                onChanged: model.patchCategory,
                onDeleted: model.deleteCategory,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const Divider(color: Colors.white12, height: 0),
      ),
    );
  }
}
