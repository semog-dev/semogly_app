import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/services/loading_service.dart';
import 'package:semogly_app/core/interceptors/auth_interceptor.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/message_service.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://semogly-api.onrender.com/api",
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        contentType: 'application/json',
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    _configureSSL();
    _addLoadingInterceptor();
  }

  Dio get dio => _dio;

  void _configureSSL() {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
  }

  void _addLoadingInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.extra['showLoading'] ?? true) {
            getIt<LoadingService>().show();
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.requestOptions.extra['showLoading'] ?? true) {
            getIt<LoadingService>().hide();
          }
          return handler.next(response);
        },
        onError: (e, handler) {
          if (e.requestOptions.extra['showLoading'] ?? true) {
            getIt<LoadingService>().hide();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> init() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final storagePath = "${appDocDir.path}/.cookies/";
    await Directory(storagePath).create(recursive: true);

    final cookieJar = PersistCookieJar(
      storage: FileStorage(storagePath),
      ignoreExpires: false,
    );
    _dio.interceptors.add(CookieManager(cookieJar));

    _dio.interceptors.add(
      AuthInterceptor(
        dio: _dio,
        accountRepository: getIt<IAccountRepository>(),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('🌐 API: $obj'),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          final statusCode = e.response?.statusCode;
          String errorMessage = "Ocorreu um erro inesperado";

          if (statusCode == 401) {
            if (e.requestOptions.extra['showLoading'] ?? true) {
              getIt<LoadingService>().hide();
            }

            return handler.next(e);
          }

          if (e.type == DioExceptionType.connectionTimeout) {
            errorMessage = "Servidor demorou a responder (Render acordando?)";
          } else if (e.response != null) {
            errorMessage =
                e.response?.data['message'] ??
                "Erro: ${e.response?.statusCode}";
          }

          getIt<MessageService>().showError(errorMessage);

          return handler.next(e);
        },
      ),
    );
  }
}
