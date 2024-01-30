import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_req_edit.dart';
import 'package:final_project_app/providers/auth_provider.dart';
import 'package:final_project_app/screens/nav_drawers/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/entries_provider.dart';

class UserEditRequests extends StatefulWidget {
  const UserEditRequests({super.key});

  @override
  State<UserEditRequests> createState() => UserEditRequestsState();
}

class UserEditRequestsState extends State<UserEditRequests> {
  @override
  Widget build(BuildContext context) {
    String currentUserUid = context.read<AuthProvider>().currentUserUid;
    Stream<QuerySnapshot> userEditRequestsStream =
        context.read<EntriesProvider>().editRequestsbyOwner(currentUserUid);

    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        title: const Text("My Edit Requests"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
          stream: userEditRequestsStream,
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return const Center(child: Text("No edit requests"));
            } else if (snapshots.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: ((context, index) {
                  FirestoreRequestEdit data = FirestoreRequestEdit.fromJson(
                      snapshots.data!.docs[index].data()
                          as Map<String, dynamic>);
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(data.entryId),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Status: ${data.action}"),
                            Text("Date Requested: ${data.dateRequested}"),
                            Text("Date Approved: ${data.dateApproved}")
                          ]),
                    ),
                  );
                }));
          }),
    );
  }
}
