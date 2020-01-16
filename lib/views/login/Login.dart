import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../utils/RequestUtil.dart';

/// 登录模块
class LoginWidget extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String userName;
  String userPassword;

  // 请求登录
  void login() async {
    var loginForm = formKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();
      print('userName：' + userName + '，password：' + userPassword);
      try {
       await RequestUtil.getInstance().post('/user/login', data: {'userName': userName, 'userPassword': userPassword});
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('登录'),
      ),
      body: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            margin: EdgeInsets.only(top: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: '用户名'),
                    validator: (value) { // 校验
                      if (value?.length < 3) {
                        return '用户名必须大于等于 3 个字符';
                      }else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      userName = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: '密码'),
                    obscureText: true,
                    validator: (value) {
                      if (value?.length < 6) {// 校验
                        return '密码必须大于或等于 6 个字符';
                      }else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      userPassword = value;
                    }
                  ),
                 Container(
                   margin: EdgeInsets.only(top: 60.0),
                   alignment: Alignment.center,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: <Widget>[
                       Container(
                         width: 160.0,
                         child: RaisedButton(
                           child: new Text('登录',style: TextStyle(letterSpacing: 8)),
                           color: Colors.blue,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                           textColor: Colors.white,
                           onPressed: login,
                         ),
                       ),
                       Container(
                         width: 90,
                         child: RaisedButton(
                           child: new Text('注册',style: TextStyle(letterSpacing: 8)),
                           color: Colors.white,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                           textColor: Colors.black,
                           onPressed: () {},
                         ),
                       ),
                     ],
                   )
                 )
                ],
              ),
            ),
          )
      ),
    );
  }
}