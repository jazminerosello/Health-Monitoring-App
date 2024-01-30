
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

import '../models/firestore_req_edit.dart';

class FirebaseEntriesAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseAuthAPI authAPI = FirebaseAuthAPI();

  //para kapag mag-Add ng record
  Future<String> addEntry(Map<String, dynamic> e) async {
    String? currentUserUid = auth.currentUser?.uid;
    DocumentReference docRef = await db
        .collection("users")
        .doc(currentUserUid)
        .collection("entries")
        .add(e);
    await db
        .collection("users")
        .doc(currentUserUid)
        .collection("entries")
        .doc(docRef.id)
        .update({'entryId': docRef.id});
    return docRef.id;
  }

  Future<String> addEditReq(Map<String, dynamic> e) async {
    try {
      await db.collection("editEntriesRequest").add(e);
      return "Successfully added an entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getEditReqEntries() {
    return db.collection("editEntriesRequest").snapshots();
  }

  Stream<QuerySnapshot> getDeleteReqEntries() {
    return db.collection("deleteEntriesReq").snapshots();
  }

  Future<String> addDeleteReq(Map<String, dynamic> e) async {
    try {
      await db.collection("deleteEntriesReq").add(e);
      return "Successfully added an entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // //to get the collection in database
  // Stream<QuerySnapshot> getAllEntries() {
  //   return db.collection("entries").snapshots();
  // }

  //to get the collection in database
  //to get the collection in database
  Stream<QuerySnapshot> getUserEntries() {
    String? currentUserUid = auth.currentUser?.uid;
    Stream<QuerySnapshot>? userStream;
    try {
      userStream = db
          .collection("users")
          .doc(currentUserUid)
          .collection("entries")
          .snapshots();
    } on FirebaseException {
      rethrow;
    }
    return userStream;
    // get all entries where entryId is equal to user uid
  }

  Stream<QuerySnapshot> getTodayEntry() {
    User currentUser = auth.currentUser!;
    final uuid = currentUser.uid.toString();
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";

    try {
      return db
          .collection("users")
          .doc(uuid)
          .collection("entries")
          .where("entryDate", isEqualTo: dateStr)
          .snapshots();
    } on FirebaseException {
      rethrow;
    }
  }

  //for deleting
  Future<String> deleteEntry(String? id) async {
    try {
      await db.collection("entries").doc(id).delete();

      return "Successfully deleted a record!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> approvedEdit(
      FirestoreRequestEdit newEntry, String id, String action) async {
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";
    try {
      await db
          .collection("users")
          .doc(newEntry.entryOwner)
          .collection("entries")
          .doc(id)
          .get()
          .then((snapshot) {
        if (snapshot.data()!.isNotEmpty) {
          // Update the document with the newEntry data
          snapshot.reference.update({
            // Update the fields you want to change in the document
            "colds": newEntry.colds,
            "cough": newEntry.cough,
            "diarrhea": newEntry.diarrhea,

            "difficultyBreathing": newEntry.difficultyBreathing,
            "entryDate": newEntry.entryDate,
            "feelingFeverish": newEntry.feelingFeverish,

            "fever": newEntry.fever,
            "lossOfSmell": newEntry.lossOfSmell,
            "lossOfTaste": newEntry.lossOfTaste,

            "musclePain": newEntry.musclePain,
            "none": newEntry.none,
            "recentContact": newEntry.recentContact,
            "soreThroat": newEntry.soreThroat,
            // Add more fields as needed
          });
          db
              .collection("editEntriesRequest")
              .where("entryId", isEqualTo: id)
              .get()
              .then((snapshot) {
            snapshot.docs.first.reference
                .update({"dateApproved": dateStr, "action": action});
          });

          return "Successfully edited a record!";
        } else {
          return "No document found with ID: $id";
        }
      });
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
    return "";
  }

  // deleteReq
  deleteReq(String owner, String id, String action) async {
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";
    try {
      if (action == "Approved") {
        await db
            .collection("users")
            .doc(owner)
            .collection("entries")
            .doc(id)
            .delete();
        DocumentReference docRef = await db
            .collection("deleteEntriesReq")
            .where("entryId", isEqualTo: id)
            .get()
            .then((snapshot) {
          return snapshot.docs.first.reference;
        });
        await db.collection("deleteEntriesReq").doc(docRef.id).delete();
        return "Successfully deleted a record!";
      } else {
        return "Request rejected";
      }
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Map<String, dynamic> getEntryDataById(String id) {
    Map<String, dynamic> data = {};
    try {
      DocumentReference docRef = db
          .collection("users")
          .doc(authAPI.getCurrentUid)
          .collection("entries")
          .doc(id);
      docRef
          .get()
          .then((snapshot) => data = snapshot.data() as Map<String, dynamic>);
      return data;
    } on FirebaseException {
      rethrow;
    }
  }

  // gets all edit requests made by specific user
  Stream<QuerySnapshot> getEditRequestsByOwner(String owner) {
    Stream<QuerySnapshot> dataStream;
    try {
      dataStream = db
          .collection("editEntriesRequest")
          .where("entryOwner", isEqualTo: owner)
          .snapshots();
      return dataStream;
    } on FirebaseException {
      rethrow;
    }
  }

  // gets all delete requests by specific user
  Stream<QuerySnapshot> getDeleteRequestsByOwner(String owner) {
    Stream<QuerySnapshot> dataStream;
    try {
      dataStream = db
          .collection("deleteEntriesReq")
          .where("entryOwner", isEqualTo: owner)
          .snapshots();
      return dataStream;
    } on FirebaseException {
      rethrow;
    }
  }
}
