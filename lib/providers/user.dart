import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_flutter/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(String user) {
    _user = User.fromJson(json.decode(user));
    notifyListeners();
  }
}
