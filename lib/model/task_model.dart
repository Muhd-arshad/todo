import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String docid;
  final String id;
  final String title;
  final String description;
  final String time;
  final String date;
  final Timestamp timestamp;

  TaskModel({
    required this.docid,
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.timestamp,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TaskModel(
      docid: doc.id,
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
