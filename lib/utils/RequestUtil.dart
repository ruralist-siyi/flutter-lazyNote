import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'PromptUtil.dart';

/// 基于dio的request封装
class RequestUtil {
  Dio dio = new Dio();
  static RequestUtil _instance;

  RequestUtil() {
    String platform = Platform.isAndroid ? 'android' : 'ios';
    dio.options.headers = {"version": "0.01", "Authorization": "Bearer ", "platform": platform};
    dio.options.baseUrl = "http://47.98.40.154:3000";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
  }

  static RequestUtil getInstance() {
    if (_instance == null) {
      _instance = RequestUtil();
    }
    return _instance;
  }

  post(String url, {Map data, Function onSuccess, Function onError}) {
    _request(url, data: data, onSuccess: onSuccess, onError: onError);
  }

  _request(String url,
      {String method = 'POST',
      Map data,
      Function onSuccess,
      Function onError}) async {
    Response response;
    try {
      if (method == 'GET') {
        if (data != null && data.isNotEmpty) {
          response = await dio.get(url, queryParameters: data);
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'POST') {
        if (data != null && data.isNotEmpty) {
          response = await dio.post(url, data: data);
        } else {
          response = await dio.post(url);
        }
        String dataStr = json.encode(response.data);
        Map<String, dynamic> dataMap = json.decode(dataStr);
        if (dataMap['code'] == '000000') {
          return dataMap['data'];
        } else {
          PromptUtil.openToast((dataMap['msg'] != null && dataMap['msg'] != '') ? dataMap['msg'] : '请求异常');
        }
      }
    } on DioError catch (error) {
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
        if (error.type == DioErrorType.CONNECT_TIMEOUT) {
//          errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
        }
        // 一般服务器错误
        else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
//          errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
        }

      }
    }
  }
}
