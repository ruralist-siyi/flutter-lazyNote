import 'package:flutter/cupertino.dart';

class UserProviderModel extends ChangeNotifier {
  num userId;
  String userName;
  String phone;
  String email;

  void refresh() {
    notifyListeners();
  }

  setUserData({num userId, String userName, String phone, String email}) {
    if (userId != null) {
      this.userId = userId;
    }
    if (userName != null) {
      this.userName = userName;
    }
    if (phone != null) {
      this.phone = phone;
    }
    if (email != null) {
      this.email = email;
    }
    refresh();
  }

  clear() {
    this.userId = null;
    this.userName = null;
    this.phone = null;
    this.email = null;
    refresh();
  }
}
