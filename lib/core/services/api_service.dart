import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://10.0.2.2:7241/api",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  Dio get dio => _dio;

  Future<void> init() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final storagePath = "${appDocDir.path}/.cookies/";

    await Directory(storagePath).create(recursive: true);

    final cookieJar = PersistCookieJar(
      storage: FileStorage(storagePath),
      ignoreExpires: false,
    );

    _dio.interceptors.add(CookieManager(cookieJar));
  }
}
