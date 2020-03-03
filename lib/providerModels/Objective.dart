import 'package:flutter/cupertino.dart';

class ObjectiveProviderModel extends ChangeNotifier {
  List objectiveList = [];
  num totalCount = 0;

  void refresh() {
    notifyListeners();
  }

  setObjectiveListData(List objectiveList, num totalCount) {
    this.objectiveList = objectiveList;
    this.totalCount = totalCount;
    refresh();
  }
}
