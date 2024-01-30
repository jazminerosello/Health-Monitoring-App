import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/providers/entries_provider.dart';
import 'package:final_project_app/screens/nav_drawers/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> curUserInfo =
        context.watch<AuthProvider>().currentUserInfo;
    //todayEntry
    Stream<QuerySnapshot> todayEntry =
        context.watch<EntriesProvider>().todayEntry;

    return Scaffold(
      drawer: const UserDrawer(),
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

            bool canGenerateQr = user['status'] != "Quarantine" &&
                user['status'] != "No Entry" &&
                user['status'] != "With symptoms" &&
                user['status'] != "Monitoring";

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
                child: ListView(shrinkWrap: true, children: [
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("UID:"),
                        Text("Name:"),
                        Text("Username:"),
                        Text("Email"),
                        Text("Student Number: "),
                        Divider(),
                        Text("Course"),
                        Text("College:"),
                        Text("Status:")
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(user['uid']),
                        Text("${user['lastname']}, ${user['firstname']}"),
                        Text(user['username']),
                        Text(user['email']),
                        Text(user['studentNo']),
                        const Divider(),
                        Text(user['course']),
                        Text(user['college']),
                        Text(user['status'])
                      ])
                ],
              ),
              const SizedBox(
                height: 120,
              ),
              if (canGenerateQr)
                Center(
                  child: QrImageView(
                    data:
                        "This is ${user['lastname']}, ${user['firstname']}'s building pass.",
                    version: QrVersions.auto,
                    size: 150,
                    gapless: false,
                  ),
                )
              else
                Center(
                  child: Text(
                    "QR code cannot be generated because your status is ${user['status']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ]));
          }),
    );
  }
}
