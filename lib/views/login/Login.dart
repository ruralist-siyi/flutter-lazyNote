import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/HttpUtil.dart';
import '../../utils/PromptUtil.dart';
import '../../models/index.dart';

/// 登录模块
class LoginWidget extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String userName;
  String userPassword;
  bool loginBtnStatus = false;

  // 请求登录
  void login() async {
    var loginForm = formKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();
      loginBtnStatus = true;
      try {
        var res = await Http.getInstance().post('/user/login',
            data: {'userName': userName, 'userPassword': userPassword});
        if (res != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userInfo', UserInfoModel.fromJson(res).toString());
          PromptUtil.openToast('登录成功', bgColor: Colors.blue);
          Navigator.pushNamed(context, '/');
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          loginBtnStatus = false;
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
    // WillPopScope: 返回事件拦截器 监听实体/虚拟返回键和AppBar返回键
    return WillPopScope(
      onWillPop: routePop,
      child: Scaffold(
        // 是否调整主体的大小以避免键盘遮挡部分布局
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('登录')),
        body: Center(
            child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
          margin: EdgeInsets.only(top: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: '用户名'),
                  validator: (value) {
                    // 校验
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
                    decoration: InputDecoration(hintText: '密码'),
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
                Container(
                    margin: EdgeInsets.only(top: 60.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 160.0,
                          child: RaisedButton(
                            child: new Text('登录',
                                style: TextStyle(letterSpacing: 8)),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            textColor: Colors.white,
                            onPressed: !loginBtnStatus ? login : null,
                          ),
                        ),
                        Container(
                          width: 90,
                          child: RaisedButton(
                            child: new Text('注册',
                                style: TextStyle(letterSpacing: 8)),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            textColor: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
