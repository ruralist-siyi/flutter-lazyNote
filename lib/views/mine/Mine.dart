import 'package:flutter/material.dart';

/// 个人中心模块
class MineWidget extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<MineWidget> {

  @override
  void initState() {
    print('Mine render');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: [
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
                    onTap: (){
                      print('hahahaha');
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset("images/xiongmao.png", width: 65),
                        Container(
                          child: Text(
                              'hi~请登录',
                              style: TextStyle(color: Colors.white, fontSize: 16.0)
                          ),
                          margin: EdgeInsets.only(top: 10.0),
                        )
                      ],
                    ),
                  )
                ),
              ),
            ]
          ),
         Container(
           child: Column(
             children: <Widget>[
               Container(
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                     border: Border(
                       bottom: Divider.createBorderSide(context, color: Colors.grey),
                     )
                 ),
                 child: Flex(
                   direction: Axis.horizontal,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Row(
                       children: <Widget>[
                         Image.asset("images/target.png", width: 30),
                         Container(
                           child: Text('建小目标'),
                           margin: EdgeInsets.only(left: 10.0),
                         )
                       ],
                     ),
                     Icon(Icons.arrow_right, color: Colors.grey)
                   ],
                 )
               ),
               Container(
                   padding: EdgeInsets.all(10),
                   decoration: BoxDecoration(
                       border: Border(
                         bottom: Divider.createBorderSide(context, color: Colors.grey),
                       )
                   ),
                   child: Flex(
                     direction: Axis.horizontal,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                           Image.asset("images/notebook.png", width: 30),
                           Container(
                             child: Text('记小本本'),
                             margin: EdgeInsets.only(left: 10.0),
                           )
                         ],
                       ),
                       Icon(Icons.arrow_right, color: Colors.grey)
                     ],
                   )
               ),
               Container(
                   padding: EdgeInsets.all(10),
                   decoration: BoxDecoration(
                       border: Border(
                         bottom: Divider.createBorderSide(context, color: Colors.grey),
                       )
                   ),
                   child: Flex(
                     direction: Axis.horizontal,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                           Image.asset("images/exit.png", width: 30),
                           Container(
                             child: Text('退出登录'),
                             margin: EdgeInsets.only(left: 10.0),
                           )
                         ],
                       ),
                       Icon(Icons.arrow_right, color: Colors.grey)
                     ],
                   )
               ),
             ],
           ),
         )
        ]
    );
  }
}