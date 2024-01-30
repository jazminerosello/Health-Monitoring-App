import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/providers/entries_provider.dart';
import 'package:final_project_app/screens/nav_drawers/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => ProfileAdminState();
}

class ProfileAdminState extends State<ProfileAdmin> {
  @override
  Widget build(BuildContext context) {
    //Stream<User?> userStream = context.watch<AuthProvider>().userStream;

    Stream<QuerySnapshot> curUserInfo =
        context.watch<AuthProvider>().currentAdminInfo;
    //todayEntry
    Stream<QuerySnapshot> todayEntry =
        context.watch<EntriesProvider>().todayEntry;

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(title: const Text('My Profile')),
      body: StreamBuilder(
          stream: curUserInfo,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Users Found"),
              );
            }

            QueryDocumentSnapshot userDoc = snapshot.data!.docs.first;
            Map<String, dynamic> user = userDoc.data() as Map<String, dynamic>;

            bool canGenerateQr = user['status'] != "Under Quarantine" &&
                user['status'] != "No Entry" &&
                user['status'] != "With symptoms" &&
                user['status'] != "Under Monitoring";

            todayEntry.listen((QuerySnapshot snapshot) {
              if (snapshot.docs.isNotEmpty) {
                if (canGenerateQr) {
                  // QrImageView(
                  //   data:
                  //       "This is ${user['lastname']}, ${user['firstname']}'s building pass.",
                  //   version: QrVersions.auto,
                  //   size: 150,
                  //   gapless: false,
                  // );
                  canGenerateQr = true;
                } else {
                  // Text(
                  //   "QR code cannot be generated because your status is ${user['status']}",
                  //   style: TextStyle(fontSize: 16),
                  // );
                  canGenerateQr = false;
                }
              }
            });

            return Center(
                child: Column(children: [
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Uid:"),
                        Text("Name:"),
                        Text("UpMail"),
                        Text("Employee Number: "),

                        Divider(),
                        Text("Home Unit"),
                        Text("Position:"),
                        // Text("Illness:")
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(user['uid']),
                        Text("${user['lastName']}, ${user['firstName']}"),
                        Text(user['email']),
                        Text(user['employeeNum']),

                        const Divider(),
                        Text(user['homeUnit']),
                        Text(user['position']),
                        //   ListView.builder(
                        //    itemCount: user.illness.isEmpty ? 1 : user.illness.length,
                        //    itemBuilder: (context, index) {
                        //     if (user.illness.isEmpty) {
                        //       return Text( "No illness");
                        //     } else {
                        //       final item = user.illness[index];
                        //       return Text( item.toString(),);
                        //     }
                        //   },
                        // )
                        // Text(user.illness)
                      ])
                ],
              ),
              const SizedBox(
                height: 120,
              ),
              if (canGenerateQr)
                QrImageView(
                  data:
                      "This is ${user['lastName']}, ${user['firstName']}'s building pass.",
                  version: QrVersions.auto,
                  size: 150,
                  gapless: false,
                )
              else
                Text(
                  "QR code cannot be generated because your status is ${user['status']}",
                  style: const TextStyle(fontSize: 16),
                ),
            ]));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) => TodoModal(
          //     type: 'Add',
          //   ),
          // );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
