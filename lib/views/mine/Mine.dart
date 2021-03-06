import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/index.dart';
import '../../utils/HttpUtil.dart';
import '../../utils/PromptUtil.dart';

/// 个人中心模块
class MineWidget extends StatefulWidget {
  @override
  MineState createState() => MineState();
}

class MineState extends State<MineWidget> {
  List listItem;

  @override
  void initState() {
    print('Mine render');
    super.initState();
    listItem = [
      {
        "icon": "images/target.png",
        "title": "建小目标",
        'key': 'addObjective',
        'method': goAddObjective
      },
      {
        "icon": "images/notebook.png",
        "title": "记小本本",
        'key': 'writeNote',
        'method': goWriteNote
      },
      {
        "icon": "images/exit.png",
        "title": "退出登录",
        'key': 'exit',
        'method': exit
      }
    ];
  }

  goWriteNote() {
    PromptUtil.openToast('功能正在开发中...',
        bgColor: Colors.white, textColor: Colors.black, fadeTime: 1);
  }

  goAddObjective() {
    if (!Provider.of<GlobalProviderModel>(context, listen: false).isLogin) {
      PromptUtil.openToast('您还未登录...',
          bgColor: Colors.white, textColor: Colors.black, fadeTime: 1);
      return;
    }
    Navigator.pushNamed(context, '/addObjective');
  }

  logout() async {
    await Http.getInstance().delete('/user/logout');
    Provider.of<GlobalProviderModel>(context, listen: false)
        .changeLoginStatus(false);
    Provider.of<UserProviderModel>(context, listen: false).clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamed(context, '/');
    PromptUtil.openToast('注销成功', bgColor: Colors.blue);
  }

  exit() async {
    if (!Provider.of<GlobalProviderModel>(context, listen: false).isLogin) {
      PromptUtil.openToast('您还未登录...',
          bgColor: Colors.white, textColor: Colors.black, fadeTime: 1);
      return;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('退出登录'),
          elevation: 2,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('确认需要退出登录吗？'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('退出'),
              onPressed: () {
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  Widget renderList() {
    List<Widget> items = [];
    for (var item in listItem) {
      items.add(GestureDetector(
        onTap: item['method'],
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
            bottom: Divider.createBorderSide(context, color: Colors.grey),
          )),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(item['icon'], width: 30),
                  Container(
                    child: Text(item['title']),
                    margin: EdgeInsets.only(left: 10.0),
                  )
                ],
              ),
              Icon(Icons.arrow_right, color: Colors.grey)
            ],
          ),
        ),
      ));
    }
    return Column(
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Consumer2<GlobalProviderModel, UserProviderModel>(
                  builder: (context, GlobalProviderModel globalInfo,
                          UserProviderModel userInfo, _) =>
                      Container(
                          color: Colors.blue,
                          height: 200,
                          padding: EdgeInsets.only(top: 50.0),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: !globalInfo.isLogin
                                ? () {
                                    Navigator.pushNamed(context, '/login');
                                  }
                                : null,
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/xiongmao.png", width: 65),
                                Container(
                                  child: Text(
                                      userInfo.userName != null && globalInfo.isLogin
                                          ? userInfo.userName
                                          : 'hi~请登录',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0)),
                                  padding: EdgeInsets.only(top: 10.0),
                                )
                              ],
                            ),
                          ))),
            ),
          ]),
      Container(child: renderList())
    ]);
  }
}
