class FirestoreMonitor {
  String uid;
  String firstName;
  String lastName;
  String email;
  String employeeNum;
  String position;
  String homeUnit;

  FirestoreMonitor({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.employeeNum,
    this.position = 'Monitor',
    required this.homeUnit,
  });

  factory FirestoreMonitor.fromJson(Map<String, dynamic> json) {
    return FirestoreMonitor(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      employeeNum: json['employeeNum'],
      position: json['position'],
      homeUnit: json['homeUnit'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'employeeNum': employeeNum,
        'position': position,
        'homeUnit': homeUnit,
      };
}
