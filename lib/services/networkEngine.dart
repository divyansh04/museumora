import 'package:dio/dio.dart';
import 'package:museumora/services/network_interceptor.dart';

class NetworkEngine {
  static final NetworkEngine _defaultEngine = new NetworkEngine._internal();
  static String baseUrl;
  factory NetworkEngine() {
    return _defaultEngine;
  }

  NetworkEngine._internal();

  Dio get dio {
    BaseOptions options = new BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 120000,
      receiveTimeout: 120000,
    );

    Dio dio = new Dio(options);
    addInterceptor(dio);
    return dio;
  }

  addInterceptor(Dio dio) {
    dio.interceptors.add(NetworkInterceptors());
  }
}
