import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import '../app/app_prefs.dart';
import '../constants/app_constant.dart';
import 'error_handle.dart';
import 'network_info.dart';

class ApiService {
  final Dio _dio;
  final NetworkInfo _networkInfo;
  final AppPreferences _appPref;

  ApiService(this._dio, this._networkInfo, this._appPref) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        // onError: _onError,
      ),
    );
  }
  _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (await _networkInfo.isConnected) {
      String? token = _appPref.getCredential();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    } else {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: ResponseCode.noInternetConnection,
            statusMessage: ResponseMessage.noInternetConnection,
          ),
          error: ResponseMessage.noInternetConnection,
        ),
      );
    }
  }

  //
  // _onError(DioException e, ErrorInterceptorHandler handler) async {
  //   if (e.response?.statusCode == 423 && _appPref.isUserLogged()) {
  //     _logout();
  //     handler.reject(e);
  //   } else if (e.response?.statusCode == 401 && _appPref.isUserLogged()) {
  //     _refreshToken(e, handler);
  //   } else {
  //     handler.next(e);
  //   }
  // }

  //endregion


  Future<FormData> createFormData(Map<String, dynamic> data) async {
    final formData = FormData();
    for (var entry in data.entries) {
      if (entry.key == 'imageByte' && entry.value != null) {
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(entry.value , filename: 'image.jpg'),
        ));
      } else {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }
    }
    return formData;
  }


  Future<Response> get({required String endPoint, dynamic params}) async {
    var response = await _dio.get('${AppConstant.baseUrl}$endPoint',  queryParameters: params);
    return response;
  }

  Future<Response> post({required String endPoint, dynamic data, dynamic params}) async {
    var response = await _dio.post('${AppConstant.baseUrl}$endPoint', data: data, queryParameters: params);
    return response;
  }
  Future<Response> multiPartPost({required String endPoint, required Map<String, dynamic> data}) async {
    FormData formData = await createFormData(data);
    var response = await _dio.post('${AppConstant.baseUrl}$endPoint', data: formData);
    return response;
  }
  Future<Response> put({required String endPoint}) async {
    var response = await _dio.put('${AppConstant.baseUrl}$endPoint');
    return response;
  }

  Future<Response> delete({required String endPoint}) async {
    var response = await _dio.delete('${AppConstant.baseUrl}$endPoint');
    return response;
  }
}