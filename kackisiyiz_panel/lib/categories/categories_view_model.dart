import 'package:kackisiyiz_panel/categories/common/categories_api_service.dart';
import 'package:kackisiyiz_panel/core/models/category_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view_model.dart';

class CategoriesViewModel extends BaseViewModel {
  final _categoriesApiService = CategoriesApiService();
  List<CategoryModel>? categories;

  Future getCategories() async {
    setState(ViewState.busy);
    categories = await _categoriesApiService.getCategories();
    setState(ViewState.idle);
  }

  Future patchCategory(CategoryModel categoryModel) async {
    setState(ViewState.busy);
    final status = await _categoriesApiService.patchCategory(categoryModel);
    if (!status) setInfoText("Kategori bölümünde bir oluştu.");
    setState(ViewState.idle);

    if (status) await getCategories();
  }

  Future deleteCategory(int id) async {
    setState(ViewState.busy);
    final status = await _categoriesApiService.deleteCategory(id);
    setState(ViewState.idle);
    if (status) getCategories();
  }
}
