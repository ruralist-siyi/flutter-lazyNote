import 'package:flutter/material.dart';

import '../../utils/HttpUtil.dart';
import '../../utils/PromptUtil.dart';

class RegisterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<RegisterWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String userName;
  String userPassword;
  String email;
  String phone;
  bool registerBtnStatus = false;

  void register() async {
    var loginForm = formKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();
      registerBtnStatus = true;
      try {
        var res = await Http.getInstance().post('/user/create', data: {
          'userName': userName,
          'userPassword': userPassword,
          'email': email,
          'phone': phone
        });
        if (res != null) {
          PromptUtil.openToast('注册成功去登陆！', bgColor: Colors.blue);
          Navigator.pushNamed(context, '/login');
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          registerBtnStatus = false;
        });
      }
    }
  }

  // 监听返回
  Future<bool> routePop() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
    return new Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: routePop,
      child: Scaffold(
          appBar: AppBar(title: Text('注册')),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                margin: EdgeInsets.only(top: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: '用户名',hintText: '用户名'),
                        validator: (value) {
                          if (value?.length < 3) {
                            return '用户名必须大于等于 3 个字符';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          userName = value;
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: '密码',hintText: '请输入密码'),
                          obscureText: true,
                          validator: (value) {
                            if (value?.length < 6) {
                              // 校验
                              return '密码必须大于或等于 6 个字符';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            userPassword = value;
                          }),
                      TextFormField(
                        decoration: InputDecoration(labelText: '邮箱',hintText: '请输入邮箱'),
                        validator: (value) {
                          final emailReg = new RegExp(
                              '^[A-Za-z0-9]+([_\.][A-Za-z0-9]+)*@([A-Za-z0-9\-]+\.)+[A-Za-z]{2,6}\$');
                          if (value != '' && !emailReg.hasMatch(value)) {
                            return '请输入正确格式的邮箱地址';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: '手机号',hintText: '请输入手机号'),
                        validator: (value) {
                          final phoneReg = new RegExp('^[1][0-9]{10}\$');
                          if (value != '' && !phoneReg.hasMatch(value)) {
                            return '请输入正确格式的手机号';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          phone = value;
                        },
                      ),
                      Container(
                        width: 200,
                        margin: EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          child: new Text('注册',
                              style: TextStyle(letterSpacing: 8)),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          textColor: Colors.white,
                          onPressed: !registerBtnStatus ? register : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
