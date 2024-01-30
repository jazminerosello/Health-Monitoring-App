import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_user_request.dart';
import 'package:final_project_app/providers/entries_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'nav_drawers/admin_drawer.dart';

class DeleteRequest extends StatefulWidget {
  const DeleteRequest({super.key});

  @override
  State<DeleteRequest> createState() => DeleteRequestState();
}

class DeleteRequestState extends State<DeleteRequest> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> entriesStream =
        context.watch<EntriesProvider>().deleteEntries;

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
          title: const Text('Delete Requests',
              style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville")),
          backgroundColor: const Color.fromARGB(255, 203, 141, 141)),
      body: StreamBuilder(
        stream: entriesStream,
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
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Column(children: [
              SizedBox(height: 90),
              Text(
                "No Entries yet!",
              )
            ]));
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              FirestoreRequest currentEntry = FirestoreRequest.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              return ListTile(
                title: Text(currentEntry.entryId),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status: ${currentEntry.action}"),
                    Text("Date Requested: ${currentEntry.dateRequested}"),
                    Text("Date Approved: ${currentEntry.dateApproved}")
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<EntriesProvider>().deleteAction(
                            currentEntry.entryOwner,
                            currentEntry.entryId,
                            "Approved");
                      },
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<EntriesProvider>().deleteAction(
                            currentEntry.entryOwner,
                            currentEntry.entryId,
                            "Rejected");
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
  

  // }
