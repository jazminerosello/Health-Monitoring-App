import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_admin_model.dart';
import 'package:final_project_app/models/firestore_monitor_model.dart';
import 'package:final_project_app/models/firestore_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/firestore_entry_model.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  String get getCurrentUid => auth.currentUser!.uid;

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    Map<String, dynamic> user = {};
    try {
      QuerySnapshot snapshot =
          await db.collection("users").where("uid", isEqualTo: uid).get();
      user = snapshot.docs.first.data() as Map<String, dynamic>;
    } on FirebaseException {
      rethrow;
    }
    return user;
  }

  Stream<QuerySnapshot> getAllUsersInfo() {
    return db.collection("users").snapshots();
  }

  Stream<QuerySnapshot> getCurrentUserInfo() {
    late final uuid = FirebaseAuth.instance.currentUser?.uid;

    return db.collection("users").where("uid", isEqualTo: uuid).snapshots();
  }

  Stream<QuerySnapshot> getCurrentAdminInfo() {
    late final uuid = FirebaseAuth.instance.currentUser?.uid;

    return db.collection("admins").where("uid", isEqualTo: uuid).snapshots();
  }

//getQuarantinedUser
  Stream<QuerySnapshot> getQuarantinedUser() {
    return db
        .collection("users")
        .where("status", isEqualTo: "Quarantine")
        .snapshots();
  }

//getMonitoredUser(
  Stream<QuerySnapshot> getMonitoredUser() {
    return db
        .collection("users")
        .where("status", isEqualTo: "Monitoring")
        .snapshots();
  }

  Future<void> editStat(String stat, String u) async {
    try {
      User? currentUser = auth.currentUser;
      String uuid = currentUser!.uid.toString();

      final querySnapshot =
          await db.collection("users").where("uid", isEqualTo: uuid).get();

      final documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        final document = documents.first;
        final docRef = db.collection("users").doc(document.id);

        await docRef.update({'status': stat});
      } else {
        throw Exception("Document not found");
      }
    } catch (e) {
      // Handle the error
      rethrow;
    }
  }

  Future<String> changeStatus(String stat, String id) async {
    try {
      // print("New String: $title");
      await db.collection("users").doc(id).update({"status": stat});
      debugPrint("Changed $id to status $stat");
      return "Successfully edited a record!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<void> addEntry(FirestoreEntry entry) async {
    try {
      User currentUser = auth.currentUser!;
      await db.collection("users").doc(currentUser.uid).update({
        "entries": FieldValue.arrayUnion([entry.toJson()])
      });
    } on FirebaseException {
      rethrow;
    }
  }

  Future<String> validateUserPosition(String uid) async {
    String position = "";
    try {
      await db
          .collection("admins")
          .where("uid", isEqualTo: uid)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          position = "admin";
        } else {
          await db
              .collection("monitors")
              .where("uid", isEqualTo: uid)
              .get()
              .then((value) async {
            if (value.docs.isNotEmpty) {
              position = "monitor";
            } else {
              await db
                  .collection("users")
                  .where("uid", isEqualTo: uid)
                  .get()
                  .then((value) async {
                if (value.docs.isNotEmpty) {
                  position = "user";
                }
              });
            }
          });
        }
      });
    } on FirebaseException {
      rethrow;
    }
    return Future.value(position);
  }

  Future<void> addUser(Map<String, dynamic> u) async {
    try {
      await db.collection("users").doc(u['uid']).set(u);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> addMonitor(FirestoreMonitor monitor) async {
    try {
      await db.collection("monitors").add(monitor.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> addAdmin(Map<String, dynamic> admin) async {
    try {
      await db.collection("admins").add(admin);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    String currentUid = "";
    String userPos = "";
    credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    currentUid = credential.user!.uid;
    userPos = await validateUserPosition(
        currentUid); // checks if user is admin, monitor, or user
    return Future.value(userPos);
  }

  Future<UserCredential> signUpUser(
      String email, String password, FirestoreUser newUser) async {
    UserCredential? credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirestoreUser u = FirestoreUser(
        uid: credential.user!.uid.toString(),
        username: newUser.username,
        firstname: newUser.firstname,
        lastname: newUser.lastname,
        college: newUser.college,
        course: newUser.course,
        studentNo: newUser.studentNo,
        email: newUser.email,
        illness: newUser.illness,
        status: newUser.status,
      );

      addUser(u.toJson(u));
      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.\
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      rethrow;
    }
    return (credential!);
  }

  Future<UserCredential?> signUpAdmin(
      String email, String password, FirestoreAdmin newAdmin) async {
    UserCredential? credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String newUid = credential.user!.uid;
      newAdmin.uid = newUid;

      Map<String, dynamic> newAdminJson = {
        'firstName': newAdmin.firstName,
        'lastName': newAdmin.lastName,
        'email': newAdmin.email,
        'position': newAdmin.position,
        'uid': newAdmin.uid,
        'employeeNum': newAdmin.employeeNum,
        'homeUnit': newAdmin.homeUnit
      };
      addAdmin(newAdminJson);

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.\
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserCredential> signUpMonitor(
      String email, String password, FirestoreMonitor newMonitor) async {
    UserCredential? credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String newUid = credential.user!.uid;
      newMonitor.uid = newUid;
      addMonitor(newMonitor);
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return (credential!);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
