import 'package:flutter/cupertino.dart';

class GlobalProviderModel extends ChangeNotifier {
  bool isLogin = false;

  void refresh() {
    notifyListeners();
  }

  changeLoginStatus(bool loginStatus) {
    this.isLogin = loginStatus;
    refresh();
  }
}
