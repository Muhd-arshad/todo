import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/category_model.dart';
import 'package:todo/service/todo_service.dart';

class CategoryController extends ChangeNotifier {
  CategoryController() {
    getCatories();
  }
  final TodoService _todoService = TodoService();

  List<Category> _categories = [];

  List<Category> get categories => _categories;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  bool loading = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    notifyListeners();
  }

  void setTime(TimeOfDay time, context) {
    selectedTime = time;
    timeController.text = selectedTime.format(context);
    notifyListeners();
  }

  bool loadinScreen = false;
  Future<void> getCatories() async {
    loadinScreen = true;
    log('calling');
    _categories = await _todoService.fetchCategoriesFromFirestore();
    loadinScreen = false;
    notifyListeners();
  }

  Future<bool> addCategory() async {
    loading = true;
    notifyListeners();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    bool result = await _todoService.addCategoryToFirestore(
        userId: userId ?? "",
        title: titleController.text,
        description: descriptionController.text,
        time: timeController.text,
        date: dateController.text,
        timestamp: Timestamp.now());
    loading = false;
    notifyListeners();
    return result;
  }

  Future<void> delete(String categoryId) async {
    bool result = await _todoService.deleteCategoryById(categoryId);
    if (result) {
      await getCatories();
      notifyListeners();
    }
  }

  void clearValues() {
    timeController.clear();
    dateController.clear();
    timeController.clear();
    descriptionController.clear();
    titleController.clear();
    notifyListeners();
  }
}
