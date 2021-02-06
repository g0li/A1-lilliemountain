import 'package:flutter/material.dart';
import 'package:skimscope/model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
