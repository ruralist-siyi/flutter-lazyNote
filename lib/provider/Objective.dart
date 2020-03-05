import 'package:flutter/cupertino.dart';

class ObjectiveProviderModel extends ChangeNotifier {
  List objectiveList = [];
  num totalCount = 0;
  num page = 1;
  num size = 10;

  void refresh() {
    notifyListeners();
  }

  void setPageAndSize({num page,num size}) {
    if(page != null) {
      this.page = page;
    }
    if(size != null) {
      this.size = size;
    }
    refresh();
  }

  void setObjectiveListData(List objectiveList, num totalCount) {
    this.objectiveList = objectiveList;
    this.totalCount = totalCount;
    refresh();
  }
}
