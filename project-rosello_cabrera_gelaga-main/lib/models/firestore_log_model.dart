import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreLog {
  String? location;
  String? studno;
  String? status;
  // DateTime logDate;
  String logDate;

  FirestoreLog(
      {required this.location,
      required this.studno,
      required this.status,
      required this.logDate});

  factory FirestoreLog.fromJson(Map<String, dynamic> json) {
    return FirestoreLog(
        location: json['location'],
        studno: json['studno'],
        status: json['status'],
        // logDate: (json['entryDate'] as Timestamp).toDate());
        logDate: json['logDate']);
  }

  Map<String, dynamic> toJson() => {
        'location': location,
        'studno': studno,
        'status': status,
        'logDate': logDate
      };
}
