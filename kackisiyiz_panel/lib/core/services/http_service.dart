import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kackisiyiz_panel/core/app/locator.dart';
import 'package:kackisiyiz_panel/login/login_view_model.dart';
import 'package:kackisiyiz_panel/core/constants/hosts.dart';

enum HttpMethod { get, put, post, patch, delete }

class HttpService {
  late final BaseOptions _options;
  late final Dio _dio;

  HttpService()
      : _options = BaseOptions(
          baseUrl: KHost.host,
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType,
        ) {
    _dio = Dio(_options);
  }

  _logException(DioException e) {
    log("${e.message}");
    if (e.response != null) {
      log("${[e.response!.statusCode]}: ${e.response!.data}");
    }
  }

  Future<String?> _getToken() async {
    final loginViewModel = locator<LoginViewModel>();
    try {
      final response = await _dio
          .post(KHost.token, data: {"mainToken": loginViewModel.userToken});
      return response.data['token'];
    } on DioException catch (e) {
      _logException(e);
    }
    return null;
  }

  Future<Response?> request({
    required String url,
    required HttpMethod method,
    Map<String, dynamic>? data,
    bool withToken = false,
  }) async {
    // Request method
    final req = switch (method) {
      HttpMethod.get => _dio.get,
      HttpMethod.post => _dio.post,
      HttpMethod.patch => _dio.patch,
      HttpMethod.delete => _dio.delete,
      HttpMethod.put => _dio.put,
    };
    final bool withArgs = method == HttpMethod.get;

    Options extra = Options();

    if (withToken) {
      final token = await _getToken();
      if (token == null) {
        log("Token getirilemedi");
        return null;
      }
      extra.headers = {"x-access-token": token};
    }

    try {
      final response = await req(url,
          data: !withArgs ? data : null,
          queryParameters: withArgs ? data : null,
          options: extra);
      return response;
    } on DioException catch (e) {
      _logException(e);
    }
    return null;
  }
}
