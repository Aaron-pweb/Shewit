import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    // Logging Interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
    
    // Auth Interceptor for injecting token if needed
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TODO: Read token from Secure Storage and inject
        // final token = await secureStorage.read(key: 'auth_token');
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
    ));
  }
}
