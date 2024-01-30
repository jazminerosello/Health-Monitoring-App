import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLogsAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  //to add to logs
  Future<String> addLog(Map<String, dynamic> log) async {
    try {
      DocumentReference docRef = await db.collection("logs").add(log);
      return "Success";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //to fetch a location's logs
  Stream<QuerySnapshot> getLogs() {
    return db.collection("logs").snapshots();
  }

  Stream<QuerySnapshot> getUserLogs(String studno) {
    try {
      return db
          .collection("logs")
          .where("studno", isEqualTo: studno)
          .snapshots();
    } on FirebaseException {
      rethrow;
    }
  }
}
