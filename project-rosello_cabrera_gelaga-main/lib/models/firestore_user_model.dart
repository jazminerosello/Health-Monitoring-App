import 'dart:convert';

class FirestoreUser {
  String? uid;
  String? username;
  String? firstname;
  String? lastname;
  String? college;
  String? course;
  String? studentNo;
  String? email;
  String? status;

  List<dynamic> illness;

  FirestoreUser(
      {required this.uid,
      required this.username,
      required this.firstname,
      required this.lastname,
      required this.college,
      required this.course,
      required this.studentNo,
      required this.email,
      required this.illness,
      required this.status});

  factory FirestoreUser.fromJson(Map<dynamic, dynamic> json) {
    return FirestoreUser(
        uid: json['uid'],
        username: json['username'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        college: json['college'],
        course: json['course'],
        studentNo: json['studentNo'],
        illness: json['illness'],
        status: json['status']);
  }

  //map the data
  static List<FirestoreUser> fromJsonArray(dynamic jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<FirestoreUser>((dynamic d) => FirestoreUser.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson(FirestoreUser u) => {
        'uid': u.uid,
        'username': u.username,
        'firstname': u.firstname,
        'lastname': u.lastname,
        'college': u.college,
        'course': u.course,
        'studentNo': u.studentNo,
        'email': u.email,
        'illness': u.illness,
        "status": u.status,
      };
}
