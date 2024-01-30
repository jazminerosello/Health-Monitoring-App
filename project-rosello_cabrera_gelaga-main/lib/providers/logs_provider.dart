import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/logs_api.dart';

class LogsProvider with ChangeNotifier {
  late FirebaseLogsAPI firebaseService;
  late Stream<QuerySnapshot> _lStream;
  late Stream<QuerySnapshot> _studentLogsStream;

  LogsProvider() {
    firebaseService = FirebaseLogsAPI();
  }

  Stream<QuerySnapshot> get log {
    _lStream = firebaseService.getLogs();
    return _lStream;
  }

  Stream<QuerySnapshot> studentLogs(String studno) {
    _studentLogsStream = firebaseService.getUserLogs(studno);
    return _studentLogsStream;
  }
}
