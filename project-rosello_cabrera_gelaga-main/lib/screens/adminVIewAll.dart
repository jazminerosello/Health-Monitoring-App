import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_user_model.dart';
import 'package:final_project_app/screens/adminViewSpecificStudent.dart';
import 'package:final_project_app/screens/nav_drawers/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => AdminViewState();
}

class AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    //List<Todo> todoList = context.watch<TodoListProvider>().todo;
    Stream<QuerySnapshot> uStream = context.watch<AuthProvider>().userInfo;

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(title: const Text('All Users')),
      body: StreamBuilder(
        stream: uStream,
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
                title: Text(user.studentNo.toString()),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewSpecificStudent(u: user)))
                },
              );
            }),
          );
        },
      ),
    );
  }
}
