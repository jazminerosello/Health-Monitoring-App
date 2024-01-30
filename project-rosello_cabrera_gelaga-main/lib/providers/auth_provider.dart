import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';
import '../models/firestore_admin_model.dart';
import '../models/firestore_entry_model.dart';
import '../models/firestore_monitor_model.dart';
import '../models/firestore_user_model.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;

  late Stream<QuerySnapshot> _userInfoStream;
  late Stream<QuerySnapshot> _curUserInfoStream;

  User? userObj;
  late Stream<QuerySnapshot> _quarantinedUserStream;
  late Stream<QuerySnapshot> _monitoredUserStream;
  late Stream<QuerySnapshot> _curAdminInfoStream;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    fetchCurrentAdminInformation();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;

  String get currentUserUid => authService.getCurrentUid;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  Stream<QuerySnapshot> get userInfo {
    _userInfoStream = authService.getAllUsersInfo();
    return _userInfoStream;
  }

  //getCurrentUserInfo

  Stream<QuerySnapshot> get currentUserInfo {
    _curUserInfoStream = authService.getCurrentUserInfo();
    return _curUserInfoStream;
  }

  // getCurrentAdminInfo()
  Stream<QuerySnapshot> get currentAdminInfo => _curAdminInfoStream;

  fetchCurrentAdminInformation() {
    _curAdminInfoStream = authService.getCurrentAdminInfo();
    notifyListeners();
  }

  Stream<QuerySnapshot> get quarantinedUsers {
    _quarantinedUserStream = authService.getQuarantinedUser();
    return _quarantinedUserStream;
  }

  //underMonitoringUsers
  Stream<QuerySnapshot> get monitoredUsers {
    _monitoredUserStream = authService.getMonitoredUser();
    return _monitoredUserStream;
  }

  Future<void> signUpUser(
      String email, String password, FirestoreUser newUser) async {
    await authService.signUpUser(email, password, newUser);
  }

  Future<void> SignUpAdmin(
      String email, String password, FirestoreAdmin newAdmin) async {
    await authService.signUpAdmin(email, password, newAdmin);
  }

  Future<void> SignUpMonitor(
      String email, String password, FirestoreMonitor newMonitor) async {
    await authService.signUpMonitor(email, password, newMonitor);
  }

  Future<String> signIn(String email, String password) async {
    String returnUserPosition = "";
    returnUserPosition = await authService.signIn(email, password);
    notifyListeners();
    return returnUserPosition;
  }

  Future<String> validateUserPosition(String id) async {
    return authService.validateUserPosition(id);
  }

  Future<void> addEntry(FirestoreEntry newEntry) async {
    await authService.addEntry(newEntry);
    notifyListeners();
  }

  Future<void> editStatus(String s, String u) async {
    await authService.editStat(s, u);
    notifyListeners();
  }

  Future<void> changeStat(String s, String id) async {
    await authService.changeStatus(s, id);
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
