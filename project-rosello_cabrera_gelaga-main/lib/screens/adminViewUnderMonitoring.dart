import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav_drawers/admin_drawer.dart';

import '../providers/auth_provider.dart';

class AdminViewMonitored extends StatefulWidget {
  const AdminViewMonitored({super.key});

  @override
  State<AdminViewMonitored> createState() => AdminViewMonitoredState();
}

class AdminViewMonitoredState extends State<AdminViewMonitored> {
  @override
  Widget build(BuildContext context) {
    //List<Todo> todoList = context.watch<TodoListProvider>().todo;
    Stream<QuerySnapshot> qStream =
        context.watch<AuthProvider>().monitoredUsers;

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
          title: const Text('Monitored Students',
              style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville")),
          backgroundColor: const Color.fromARGB(255, 149, 89, 89)),
      body: StreamBuilder(
        stream: qStream,
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

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              FirestoreUser user = FirestoreUser.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              user.uid = snapshot.data?.docs[index].id;

              return ListTile(
                title: Text('${user.lastname}, ${user.firstname}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                      "Are you sure you want to move ${user.lastname}, ${user.firstname} to quarantine?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          context
                                              .read<AuthProvider>()
                                              .changeStat("Quarantine",
                                                  user.uid.toString());
                                          Navigator.pop(context);
                                        },
                                        child: const Text("'Yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("'No")),
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.moving),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                      "Are you sure you want to end monitoring for ${user.lastname}, ${user.firstname}?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          context
                                              .read<AuthProvider>()
                                              .changeStat("Cleared",
                                                  user.uid.toString());
                                          Navigator.pop(context);
                                        },
                                        child: const Text("'Yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("'No")),
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.stop),
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
