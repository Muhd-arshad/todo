import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/service/todo_service.dart';

class TaskController extends ChangeNotifier {
  TaskController() {
    getTasks();
  }
  final TodoService _todoService = TodoService();

  List<TaskModel> _task = [];

  List<TaskModel> get task => _task;
  final GlobalKey<FormState> formKeyForTask = GlobalKey<FormState>();
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

  bool loadingScreen = false;
  Future<void> getTasks() async {
    loadingScreen = true;
    log('calling');
    _task = await _todoService.fetchTasksFromFirestore();
    loadingScreen = false;
    notifyListeners();
  }

  Future<bool> addTask() async {
    loading = true;
    notifyListeners();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    bool result = await _todoService.addTaskToFirestore(
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

  Future<void> deleteTask(String taskId) async {
    bool result = await _todoService.deleteTaskById(taskId);
    if (result) {
      await getTasks();
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
