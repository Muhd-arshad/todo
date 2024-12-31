import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/service/todo_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController() {
    fetchUser();
  }
  UserModel? userModel;

  final TodoService _todoService = TodoService();
  void fetchUser() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    userModel = await _todoService.fetchUserFromFirestore(userId ?? "");
    notifyListeners();
    if (userModel != null) {
      log('User fetched: ${userModel?.name}, ${userModel?.email ?? ""}');
    } else {
      log('Failed to fetch user');
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      log('User successfully logged out');
    } catch (e) {
      log('Error during logout: $e');
    }
  }
}
