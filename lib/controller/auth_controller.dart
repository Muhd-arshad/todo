import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/service/auth_service.dart';
import 'package:todo/service/todo_service.dart';

class AuthController extends ChangeNotifier {
  AuthService _authService = AuthService();
  TodoService _todoService = TodoService();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  bool loading = false;
  String userid = '';
  Future<bool> login(context) async {
    loading = true;
    notifyListeners();
    try {
      User? user =
          await _authService.signin(emailAddress.text, password.text, context);
      if (user != null) {
        userid = user.uid;

        loading = false;
        notifyListeners();
        return true;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log('Failed with an exception $e');
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> userSigup(context) async {
    loading = true;
    notifyListeners();
    try {
      User? user = await _authService.userSignup(
          emailAddress.text, password.text, context);

      if (user != null) {
        userid = user.uid;
        await _todoService.addUserToFirestore(
            userId: userid, email: emailAddress.text, name: name.text);
        loading = false;
        notifyListeners();
        return true;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log('failed with an exception$e');
      loading = false;
      notifyListeners();
      return false;
    }
  }

  void clearValueinController() {
    emailAddress.clear();
    password.clear();
    name.clear();
    notifyListeners();
  }

  void changeScreen() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  Future<bool> forgotPassword(context) async {
    bool result = await _todoService.resetPassword(emailAddress.text, context);
    return result;
  }
}
