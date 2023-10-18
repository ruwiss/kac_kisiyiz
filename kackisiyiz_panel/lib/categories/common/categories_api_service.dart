import 'package:kackisiyiz_panel/core/services/category_api_service.dart';
import 'package:kackisiyiz_panel/core/services/http_service.dart';
import '../../core/models/category_model.dart';
import '../../core/app/locator.dart';
import '../../core/constants/hosts.dart';

class CategoriesApiService extends CategoryApiService {
  final _http = locator<HttpService>();

  Future<bool> patchCategory(CategoryModel categoryModel) async {
    final bool isUpdate = categoryModel.id != null;
    final response = await _http.request(
        url: KHost.categoryData,
        method: isUpdate ? HttpMethod.patch : HttpMethod.post,
        withToken: true,
        data: categoryModel.toJson());

    return response != null && response.statusCode == 200;
  }

  Future<bool> deleteCategory(int id) async {
    final response = await _http.request(
        url: KHost.categoryData,
        method: HttpMethod.delete,
        withToken: true,
        data: {"id": id});

    return response != null && response.statusCode == 200;
  }
}
