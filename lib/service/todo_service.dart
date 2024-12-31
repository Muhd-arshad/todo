import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/constants/flushbar.dart';
import 'package:todo/model/category_model.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/model/user_model.dart';

class TodoService {
  Future<bool> addUserToFirestore({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'id': userId,
        'name': name,
        'email': email,
      });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        log('User added to Firestore successfully');
        return true;
      } else {
        log('User addition to Firestore failed');
        return false;
      }
    } catch (e) {
      log('Error adding user to Firestore: $e');
      return false;
    }
  }

  Future<bool> addCategoryToFirestore({
    required String userId,
    required String title,
    required String description,
    required String time,
    required String date,
    required Timestamp timestamp,
  }) async {
    try {
      final categoryRef =
          await FirebaseFirestore.instance.collection('categories').add({
        'id': userId,
        'title': title,
        'description': description,
        'time': time,
        'date': date,
        'timestamp': timestamp,
      });

      final categoryDoc = await categoryRef.get();

      if (categoryDoc.exists) {
        log('Category added to Firestore successfully');
        return true;
      } else {
        log('Category addition to Firestore failed');
        return false;
      }
    } catch (e) {
      log('Error adding category to Firestore: $e');
      return false;
    }
  }

  Future<bool> deleteCategoryById(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();

      log('Category with ID $categoryId deleted successfully');
      return true;
    } catch (e) {
      log('Error deleting category with ID $categoryId: $e');
      return false;
    }
  }

  Future<List<Category>> fetchCategoriesFromFirestore() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      log('userid$userId');
      if (userId != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('categories')
            .where('id', isEqualTo: userId)
            .get();
        log('Number of documents fetched: ${snapshot.docs.length}');
        log('sanpshot ===${snapshot.docs}');
        List<Category> categories =
            snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
        log('list==== $categories');
        return categories;
      } else {
        print('No user is logged in.');
        return [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<TaskModel>> fetchTasksFromFirestore() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      log('userid$userId');
      if (userId != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('id', isEqualTo: userId)
            .get();
        log('Number of documents fetched: ${snapshot.docs.length}');
        log('sanpshot ===${snapshot.docs}');
        List<TaskModel> task =
            snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
        log('list==== $task');
        return task;
      } else {
        print('No user is logged in.');
        return [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<bool> addTaskToFirestore({
    required String userId,
    required String title,
    required String description,
    required String time,
    required String date,
    required Timestamp timestamp,
  }) async {
    try {
      final taskRef = await FirebaseFirestore.instance.collection('tasks').add({
        'id': userId,
        'title': title,
        'description': description,
        'time': time,
        'date': date,
        'timestamp': timestamp,
      });

      final taskDoc = await taskRef.get();

      if (taskDoc.exists) {
        log('Task added to Firestore successfully');
        return true;
      } else {
        log('Task addition to Firestore failed');
        return false;
      }
    } catch (e) {
      log('Error adding category to Firestore: $e');
      return false;
    }
  }

  Future<UserModel?> fetchUserFromFirestore(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          return UserModel.fromFirestore(data);
        }
      }
      log('User not found in Firestore');
      return null;
    } catch (e) {
      log('Error fetching user: $e');
      return null;
    }
  }

  Future<bool> deleteTaskById(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();

      log('Category with ID $taskId deleted successfully');
      return true;
    } catch (e) {
      log('Error deleting category with ID $taskId: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email, context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      log('Password reset email sent successfully');
      return true;
    } on SocketException {
      showFlushbar(context, "No Internet Connection");
      return false;
    } catch (error) {
      print('Error sending password reset email: $error');
      return false;
    }
  }
}
