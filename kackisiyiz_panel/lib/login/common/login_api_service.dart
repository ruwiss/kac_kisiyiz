import '../../core/app/locator.dart';
import '../../core/constants/hosts.dart';
import '../../core/services/http_service.dart';

class LoginApiService {
  final _http = locator<HttpService>();
  
  Future<String?> login(String mail, String password) async {
    final response = await _http.request(
      url: KHost.auth,
      method: HttpMethod.get,
      data: {"mail": mail, "password": password},
    );
    if (response == null) return null;
    return response.data['token'];
  }
}
