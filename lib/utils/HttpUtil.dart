import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'PromptUtil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio;

/// 基于dio的request封装
class Http {
  static Http _instance;

  Http() {
    dio = new Dio();

    String platform = Platform.isAndroid ? 'android' : 'ios';
    dio.options.headers = {
      "version": "0.01",
      "platform": platform
    };
    dio.options.baseUrl = "http://47.98.40.154:3000";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    // TODO: 这里实际上是应该要做请求处理，后续根据实际情况添加，Dialog loading的话如果要依赖context需要特殊处理，可以通过overlay去实现
    dio.interceptors.add(
      InterceptorsWrapper(
        // 接口请求前数据处理，loading开关可以在这里做
        onRequest: (options) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if(prefs.get('token') != null) {
            options.headers["Authorization"] = "Bearer " + prefs.get('token');
          }
          // 全局单例, 所以你可以在任意一个地方自定义它的样式
          EasyLoading.instance..maskType = EasyLoadingMaskType.black;
          EasyLoading.show(status: '请求中...');
          print('onRequest');
          return options;
        },
        // 接口成功返回时处理
        onResponse: (Response resp) {
          EasyLoading.dismiss();
          return resp;
        },
        // 接口报错时处理
        onError: (DioError error) {
          EasyLoading.dismiss();
          return error;
        },
      ),
    );
  }

  static Http getInstance() {
    if (dio == null) {
      _instance = Http();
    }
    return _instance;
  }

  post(String url, {Map data, Function onSuccess, Function onError}) {
    return _request(url, data: data, onSuccess: onSuccess, onError: onError);
  }

  _request(String url,
      {String method = 'POST',
      Map data,
      Function onSuccess,
      Function onError}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        print('response');
        String dataStr = json.encode(response.data);
        var authHeader = response.headers['authorization'];
        if( authHeader != null && authHeader is List) {
          if(authHeader[0] != null && authHeader[0] != prefs.get('token')) {
            prefs.setString('token', authHeader[0]);
          }
        }
        Map<String, dynamic> dataMap = json.decode(dataStr);
        if (dataMap['code'] == '000000') {
          return dataMap['data'];
        } else {
          PromptUtil.openToast((dataMap['msg'] != null && dataMap['msg'] != '')
              ? dataMap['msg']
              : '请求异常');
        }
      }
    } on DioError catch (error) {
      PromptUtil.openToast('系统未知异常');
      print(error);
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
