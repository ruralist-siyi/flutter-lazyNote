import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class RequestUtil {
  Dio dio = new Dio();
  static RequestUtil _instance;

  static RequestUtil getInstance() {
    if (_instance == null) {
      _instance = RequestUtil();
    }
    return _instance;
  }

  RequestUtil() {
    dio.options.headers = {"version": "0.01", "Authorization": "Bearer "};
    dio.options.baseUrl = "http://47.98.40.154:3000";
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
          Fluttertoast.showToast(
              msg: dataMap['msg'] != null ? dataMap['msg'] : '网络请求错误',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 2,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      }
    } on DioError catch (error) {}
  }
}
