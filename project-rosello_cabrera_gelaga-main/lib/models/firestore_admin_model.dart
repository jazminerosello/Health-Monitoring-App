class FirestoreAdmin {
  String uid;
  String firstName;
  String lastName;
  String email;
  String employeeNum;
  String position;
  String homeUnit;

  FirestoreAdmin({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.employeeNum,
    required this.position,
    required this.homeUnit,
  });

  factory FirestoreAdmin.fromJson(Map<String, dynamic> json) {
    return FirestoreAdmin(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      employeeNum: json['employeeNum'],
      position: 'Admin',
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