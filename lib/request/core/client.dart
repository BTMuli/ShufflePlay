// Package imports:
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// 获取 Interceptor
LogInterceptor getInterceptor() {
  return LogInterceptor(
    request: false,
    requestBody: false,
    requestHeader: false,
    responseBody: false,
    responseHeader: false,
    error: true,
    logPrint: (object) {
      if (object is String) {
        debugPrint(object);
      } else {
        debugPrint(object.toString());
      }
    },
  );
}

/// 请求客户端
class SprClient {
  late Dio _dio;

  /// 构造函数
  SprClient() {
    _dio = Dio(BaseOptions());
    var interceptor = getInterceptor();
    _dio.interceptors.add(interceptor);
  }

  /// 构造函数（指定 header）
  factory SprClient.withHeader(
    Map<String, dynamic> headers,
  ) {
    var client = SprClient();
    client._dio.options.headers.addAll(headers);
    return client;
  }

  /// 获取 Dio 实例
  Dio get dio => _dio;
}
