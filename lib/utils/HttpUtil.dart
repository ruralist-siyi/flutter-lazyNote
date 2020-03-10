import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/index.dart';
import 'PromptUtil.dart';

Dio dio;

/// 基于dio的request封装
class Http {
  static Http _instance;

  Http() {
    dio = new Dio();

    String platform = Platform.isAndroid ? 'android' : 'ios';
    dio.options.headers = {"version": "0.01", "platform": platform};
    dio.options.baseUrl = "http://47.98.40.154:3000";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    // TODO: 这里实际上是应该要做请求处理，后续根据实际情况添加，Dialog loading的话如果要依赖context需要特殊处理，可以通过overlay去实现
    dio.interceptors.add(
      InterceptorsWrapper(
        // 接口请求前数据处理，loading开关可以在这里做
        onRequest: (options) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.get('token') != null) {
            options.headers["Authorization"] = "Bearer " + prefs.get('token');
          }
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

  handleResponse(response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataStr = json.encode(response.data);
    var authHeader = response.headers['authorization'];
    if (authHeader != null && authHeader is List) {
      if (authHeader[0] != null && authHeader[0] != prefs.get('token')) {
        prefs.setString('token', authHeader[0]);
        _instance = Http();
      }
    }
    Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap['code'] == '000000') {
      return dataMap['data'];
    } else {
      // token过期未授权处理逻辑
      if (dataMap['code'] == '000003') {
        final globalModel = GlobalProviderModel();
        globalModel.changeLoginStatus(false);
        prefs.clear();
      }
      PromptUtil.openToast((dataMap['msg'] != null && dataMap['msg'] != '')
          ? dataMap['msg']
          : '请求异常');
      throw Exception('Error on request');
    }
  }

  post(String url, {Map data, Function onSuccess, Function onError, bool loading = true}) {
    return _request(url, data: data, onSuccess: onSuccess, onError: onError,loading: loading);
  }

  get(String url, {Map data, Function onSuccess, Function onError, bool loading = true}) {
    return _request(url,
        method: 'GET', data: data, onSuccess: onSuccess, onError: onError,loading: loading);
  }

  delete(String url, {Map data, Function onSuccess, Function onError, bool loading = true}) {
    return _request(url,
        method: 'DELETE', data: data, onSuccess: onSuccess, onError: onError, loading: loading);
  }

  _request(String url,
      {String method = 'POST',
      Map data,
      Function onSuccess,
      Function onError,
      bool loading}) async {
    Response response;
    try {
      if(loading) {
        // 全局单例, 所以你可以在任意一个地方自定义它的样式
        EasyLoading.instance..maskType = EasyLoadingMaskType.black;
        EasyLoading.show(status: '请求中...');
      }
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
      } else if (method == 'DELETE') {
        if (data != null && data.isNotEmpty) {
          response = await dio.delete(url, data: data);
        } else {
          response = await dio.delete(url);
        }
      }
      return await handleResponse(response);
    } on DioError catch (error) {
      // TODO: 这里要注意处理异常情况
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
        if(errorResponse.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final globalModel = GlobalProviderModel();
          globalModel.changeLoginStatus(false);
          prefs.clear();
          PromptUtil.openToast('登录状态过期请重新登录');
        }else {
          PromptUtil.openToast('系统未知异常');
        }
      } else {
        errorResponse = new Response(statusCode: 666);
        if (error.type == DioErrorType.CONNECT_TIMEOUT) {
          PromptUtil.openToast('请求连接超时');
        }
        else {
          PromptUtil.openToast('系统未知异常');
        }
      }
      throw Exception('Error on request');
    }
  }
}
