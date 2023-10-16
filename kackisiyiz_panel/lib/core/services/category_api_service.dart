import 'package:kackisiyiz_panel/core/services/http_service.dart';
import '../../add_survey/common/models/category_model.dart';
import '../constants/hosts.dart';

class CategoryApiService {
  final _http = HttpService();

  Future<List<CategoryModel>?> getCategories() async {
    final response =
        await _http.request(url: KHost.categories, method: HttpMethod.get);
    if (response == null) return null;

    List<CategoryModel> categories = [];
    for (var i in response.data) {
      categories.add(CategoryModel.fromJson(i));
    }
    return categories;
  }
}
