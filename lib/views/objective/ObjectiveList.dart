import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/index.dart';
import '../../providerModels/index.dart';
import '../../utils/HttpUtil.dart';

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

  fetchObjectiveList() async {
    Map<String, dynamic> params = {'page': 1, 'size': 10};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      var res =
          await Http.getInstance().get('/objective/queryForPage', data: params);
      if (res != null) {
        var data = ObjectiveListModel.fromJson(res);
        Provider.of<ObjectiveProviderModel>(context, listen: false)
            .setObjectiveListData(data.rows, data.count);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [Text('objectiveList')]);
  }
}
