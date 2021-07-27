import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Users _user;
  AuthMethods _authMethods = AuthMethods();

  Users get getUser => _user;

  Future<void> refreshUser() async {
    Users user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}