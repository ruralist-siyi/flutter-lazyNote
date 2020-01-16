import 'package:flutter/material.dart';

/// 个人中心模块
class MineWidget extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<MineWidget> {
  List listItem;

  @override
  void initState() {
    print('Mine render');
    listItem = [
      {"icon": "images/target.png", "title": "建小目标"},
      {"icon": "images/notebook.png", "title": "记小本本"},
      {"icon": "images/exit.png", "title": "退出登录"}
    ];
  }

  Widget renderList() {
    List<Widget> items = [];
    for (var item in listItem) {
      items.add(
        Container(
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
            )),
      );
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
              child: Container(
                  color: Colors.blue,
                  height: 200,
                  padding: EdgeInsets.only(top: 50.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset("images/xiongmao.png", width: 65),
                        Container(
                          child: Text('hi~请登录',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          padding: EdgeInsets.only(top: 10.0),
                        )
                      ],
                    ),
                  )),
            ),
          ]),
      Container(child: renderList())
    ]);
  }
}
