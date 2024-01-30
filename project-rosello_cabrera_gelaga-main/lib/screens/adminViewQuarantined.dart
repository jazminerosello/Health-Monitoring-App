import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'nav_drawers/admin_drawer.dart';

class AdminViewQuarantined extends StatefulWidget {
  const AdminViewQuarantined({super.key});

  @override
  State<AdminViewQuarantined> createState() => AdminViewQuarantinedState();
}

class AdminViewQuarantinedState extends State<AdminViewQuarantined> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> qStream =
        context.watch<AuthProvider>().quarantinedUsers;
    int? count;

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
          title: const Text('Quarantined Students',
              style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville")),
          backgroundColor: const Color.fromARGB(255, 149, 89, 89)),
      body: StreamBuilder(
        stream: qStream,
        builder: (context, snapshot) {
          count = snapshot.data?.docs.length;
          count = snapshot.data?.docs.length;
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
              child: Text("No users found"),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users in quarantine"));
          }

          //Text("Quarantine Student/s Count: ${count}");

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              FirestoreUser user = FirestoreUser.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              user.uid = snapshot.data?.docs[index].id;
              Text(count.toString());
              return ListTile(
                title: Text('${user.lastname}, ${user.firstname}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<AuthProvider>()
                            .changeStat("Cleared", user.uid.toString());
                      },
                      icon: const Icon(Icons.remove_circle),
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
