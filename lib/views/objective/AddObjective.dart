import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../utils/HttpUtil.dart';
import '../../utils/PromptUtil.dart';

class AddObjective extends StatefulWidget {
  @override
  AddObjectiveState createState() {
    // TODO: implement createState
    return AddObjectiveState();
  }
}

class AddObjectiveState extends State<AddObjective> {
  String startTime;
  String endTime;
  double weight = 3;
  String content;

  // 选择开始时间
  selectStartTime(context) async {
    DateTime startTime = await getDate(context);
    String time = startTime.toString();
    this.startTime = DateUtil.formatDateStr(time, format: "yyyy-MM-dd HH:mm:ss");
    setState(() {});
  }

  // 选择结束时间
  selectEndTime(context) async {
    DateTime endTime = await getDate(context);
    String time = endTime.toString();
    this.endTime = DateUtil.formatDateStr(time, format: "yyyy-MM-dd HH:mm:ss");
    setState(() {});
  }

  // datePicker 操作
  Future<DateTime> getDate(context) {
    return showDatePicker(
      locale: Locale('zh'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  // 添加目标
  addObjective() async {
    if(this.startTime == null) {
      PromptUtil.openToast('目标开始时间不能为空');
      return;
    }
    if(this.endTime == null) {
      PromptUtil.openToast('目标结束时间不能为空');
      return;
    }
    if(this.content == null) {
      PromptUtil.openToast('目标内容不能为空');
      return;
    }
    try {
      Map<String, dynamic> params = {
        'content': this.content,
        'startTime': this.startTime,
        'endTime': this.endTime,
        'weight': this.weight
      };
      await Http.getInstance()
          .post('/objective/create', data: params, loading: true);
      PromptUtil.openToast('新增成功！', bgColor: Colors.blue);
    } on Exception catch (_) {
      print('addObjective request error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('新建目标')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Column(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  selectStartTime(context);
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('目标开始时间：'),
                          Expanded(
                              child: Text(
                                  this.startTime == null ? '' : DateUtil.formatDateStr(this.startTime, format: "yyyy-MM-dd"),
                                  style: TextStyle(color: Colors.blue))),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Text('请选择'),
                              ),
                              Icon(Icons.access_time)
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider()
                  ],
                )),
            GestureDetector(
                onTap: () {
                  selectEndTime(context);
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('目标结束时间：'),
                          Expanded(
                              child: Text(
                                  this.endTime == null ? '' : DateUtil.formatDateStr(this.endTime, format: "yyyy-MM-dd"),
                                  style: TextStyle(color: Colors.blue))),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Text('请选择'),
                              ),
                              Icon(Icons.access_time)
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider()
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('重要程度：'),
                  RatingBar(
                    itemSize: 30,
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      this.weight = rating;
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text('小目标',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                    textAlign: TextAlign.left)),
            Expanded(
              child: Container(
                child: TextField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey)),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  //Normal textInputField will be displayed
                  maxLines: 10,
                  onChanged: (value) {
                    this.content = value;
                  },
                ),
              ),
            ),
            Container(
              width: 140,
              child: RaisedButton(
                child: new Text('保存', style: TextStyle(letterSpacing: 8)),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                textColor: Colors.white,
                onPressed: addObjective,
              ),
            )
          ],
        )),
      ),
    );
  }
}
