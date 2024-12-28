import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constant.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const int apiTimeOut = 60000;

class DioFactory {
  Future<Dio> getDio() async {
    Dio dio = Dio();

    Map<String, String> headers = {
      contentType: applicationJson,
      accept: applicationJson,
    };

    dio.options = BaseOptions(
      baseUrl: AppConstant.baseUrl,
      headers: headers,
      receiveTimeout: const Duration(milliseconds: apiTimeOut),
      sendTimeout: const Duration(milliseconds: apiTimeOut),
      connectTimeout: const Duration(milliseconds: apiTimeOut),
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
    }

    return dio;
  }
}