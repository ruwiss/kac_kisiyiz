import 'package:dio/dio.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/utils/strings.dart';

enum HttpMethod { get, post, patch, delete }

class HttpService {
  final _dio = Dio();

  Future<Response?> request({
    required String url,
    required HttpMethod method,
    Map<String, dynamic>? data,
  }) async {
    final req = switch (method) {
      HttpMethod.get => _dio.get,
      HttpMethod.post => _dio.post,
      HttpMethod.patch => _dio.patch,
      HttpMethod.delete => _dio.delete
    };

    final bool withArgs = method == HttpMethod.get;

    final String token = locator.get<AuthService>().resultData.token!;

    final tokenResponse =
        await _dio.post(KStrings.tokenUrl, data: {"mainToken": token});
    if (tokenResponse.statusCode == 200) {
      _dio.options = BaseOptions(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          headers: {"x-access-token": tokenResponse.data['token']});
      final response = await req(url,
          data: withArgs ? null : data,
          queryParameters: withArgs ? data : null);
      return response;
    }
    return null;
  }
}
