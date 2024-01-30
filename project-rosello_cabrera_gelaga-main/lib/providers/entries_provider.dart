import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_user_request.dart';
import 'package:flutter/material.dart';
import '../api/entries_api.dart';
import '../models/firestore_entry_model.dart';
import '../models/firestore_req_edit.dart';

class EntriesProvider with ChangeNotifier {
  late FirebaseEntriesAPI firebaseService;
  late Stream<QuerySnapshot> _eStream;
  late Stream<QuerySnapshot> _todayEntryStream;
  late Stream<QuerySnapshot> _deleteEntryStream;
  late Stream<QuerySnapshot> _editEntryStream;
  late Stream<QuerySnapshot> _editRequestsbyOwnerStream;
  late Stream<QuerySnapshot> _delRequestsbyOwnerStream;

  EntriesProvider() {
    firebaseService = FirebaseEntriesAPI();
  }

  // getter
  Stream<QuerySnapshot> get entry {
    _eStream = firebaseService.getUserEntries();
    return _eStream;
  }

  Stream<QuerySnapshot> get todayEntry {
    _todayEntryStream = firebaseService.getTodayEntry();
    return _todayEntryStream;
  }

  // getDeleteReqEntries
  Stream<QuerySnapshot> get deleteEntries {
    _deleteEntryStream = firebaseService.getDeleteReqEntries();
    return _deleteEntryStream;
  }

  Stream<QuerySnapshot> get editEntries {
    _editEntryStream = firebaseService.getEditReqEntries();
    return _editEntryStream;
  }

  FirestoreEntry getEntryDataById(String id) {
    FirestoreEntry data =
        FirestoreEntry.fromJson(firebaseService.getEntryDataById(id));
    return data;
  }

  Stream<QuerySnapshot> editRequestsbyOwner(String owner) {
    // if user wants to view their edit requests
    _editRequestsbyOwnerStream = firebaseService.getEditRequestsByOwner(owner);
    return _editRequestsbyOwnerStream;
  }

  Stream<QuerySnapshot> deleteRequestsbyOwner(String owner) {
    //if user wants to view their delete requests
    _delRequestsbyOwnerStream = firebaseService.getDeleteRequestsByOwner(owner);
    return _delRequestsbyOwnerStream;
  }

  //method to add tas ang ipapasa sa addSlambook ay nakajson format na item na
  void addEntry(FirestoreEntry e) async {
    String message = await firebaseService.addEntry(e.toJson());
    debugPrint(message);

    notifyListeners();
  }

  void editAction(FirestoreRequestEdit r, String id, String action) async {
    firebaseService.approvedEdit(r, id, action);
    notifyListeners();
  }

  // deleteAction
  void deleteAction(String owner, String id, String action) async {
    firebaseService.deleteReq(owner, id, action);
    notifyListeners();
  }

  // //for edit, tas ang ipapasa is 'yung temp na instance ng Slambook
  // void editRecord(String id, FirestoreEntry temp) async {
  //   String message = await firebaseService.editEntry(id, temp);
  //   print(message);
  //   notifyListeners();
  // }

//for deleting
  void deleteEntry(String id) async {
    String message = await firebaseService.deleteEntry(id);
    print(message);
    notifyListeners();
  }

  void editRequest(FirestoreRequestEdit r) async {
    await firebaseService.addEditReq(r.toJson());
    notifyListeners();
  }

  void deleteRequest(FirestoreRequest r) async {
    await firebaseService.addDeleteReq(r.toJson());
  }
}
