import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/index.dart';
import '../../providerModels/index.dart';
import '../../utils/HttpUtil.dart';
import 'ObjectiveItem.dart';

/// 目标列表Widget
class ObjectiveListWidget extends StatefulWidget {
  @override
  _ObjectiveListState createState() => _ObjectiveListState();
}

class _ObjectiveListState extends State<ObjectiveListWidget> {
  @override
  void initState() {
    print('objectiveList render');
    fetchObjectiveList();
  }

  // 获取目标列表数据
  fetchObjectiveList() async {
    Map<String, dynamic> params = {'page': 1, 'size': 10};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      var res = await Http.getInstance()
          .get('/objective/queryForPage', data: params, loading: false);
      if (res != null) {
        var data = ObjectiveListModel.fromJson(res);
        Provider.of<ObjectiveProviderModel>(context, listen: false)
            .setObjectiveListData(data.rows, data.count);
      }
    }
  }

  // 上拉加载方法
  onLoad() async {
    final objectiveModel =
        Provider.of<ObjectiveProviderModel>(context, listen: false);
    num currentSize = objectiveModel.size;
    objectiveModel.setPageAndSize(size: currentSize + 10);
    Map<String, dynamic> params = {'page': 1, 'size': currentSize + 10};
    var res = await Http.getInstance()
        .get('/objective/queryForPage', data: params, loading: false);
    if (res != null) {
      var data = ObjectiveListModel.fromJson(res);
      Provider.of<ObjectiveProviderModel>(context, listen: false)
          .setObjectiveListData(data.rows, data.count);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final objectiveData = Provider.of<ObjectiveProviderModel>(context);
    return Container(
      child: EasyRefresh.custom(
        header: BezierCircleHeader(),
        footer: BezierBounceFooter(),
        onRefresh: () async {
          fetchObjectiveList();
        },
        onLoad: () async {
          onLoad();
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ObjectiveItem(objectiveData.objectiveList[index], index);
              },
              childCount: objectiveData.totalCount,
            ),
          ),
        ],
      ),
    );
  }
}
