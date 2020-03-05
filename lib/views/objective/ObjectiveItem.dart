import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../utils/HttpUtil.dart';
import '../../utils/PromptUtil.dart';

/// 单个目标ObjectItem Widget
class ObjectiveItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final num index;

  ObjectiveItem(this.data, this.index);

  // 删除目标
  deleteObjective(context) async {
    Map<String, dynamic> params = {'objectiveId': this.data['objectiveId']};
    await Http.getInstance()
        .delete('/objective/delete', data: params, loading: true);
    PromptUtil.openToast('删除成功！', bgColor: Colors.blue);
    Navigator.pop(context);
  }

  // 点击删除弹出确认框
  confirmDeleteObjective(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('删除目标'),
          elevation: 2,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('确认删除此条目标吗？'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () {
                deleteObjective(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool isTop = (this.data['isTop'] is bool) && this.data['isTop'];
    String timeStr =
        DateUtil.formatDateStr(this.data['startTime'], format: "yyyy-MM-dd") +
            '  -  ' +
            DateUtil.formatDateStr(this.data['endTime'], format: "yyyy-MM-dd");
    num objectiveId = this.data['obejctiveId'];
    return Slidable(
      key: ValueKey(objectiveId),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '置顶',
          color: Colors.blue,
          icon: Icons.notifications,
        ),
        IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            confirmDeleteObjective(context);
          },
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          print(actionType);
        },
      ),
      child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                width: isTop ? 50 : 40,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(isTop
                      ? "images/top-lindang.png"
                      : "images/lindang-colorful.png"),
                  fit: BoxFit.fitWidth,
                )),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: isTop ? 0 : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.data['content'],
                        overflow: TextOverflow.ellipsis, softWrap: false),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(timeStr,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey)),
                    )
                  ],
                ),
              )),
              Container(
                width: 30,
                child: GestureDetector(
                  child: Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                ),
              )
            ],
          )),
    );
  }
}
