import 'package:dio/dio.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final IAccountRepository accountRepository;

  AuthInterceptor({required this.dio, required this.accountRepository});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path.contains('/account/refresh')) {
        await accountRepository.logout();
        return handler.next(err);
      }

      try {
        await accountRepository.refreshToken();
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
