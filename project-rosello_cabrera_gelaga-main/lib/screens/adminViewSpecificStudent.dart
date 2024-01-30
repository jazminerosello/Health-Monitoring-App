import 'package:final_project_app/models/firestore_user_model.dart';
import 'package:flutter/material.dart';

class ViewSpecificStudent extends StatelessWidget {
  const ViewSpecificStudent({super.key, required this.u});
  final FirestoreUser u;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information')),
      body: Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "UID:\t",
                    ),
                    //column for the name, nickname etc.
                    Text(
                      "Name:\t",
                    ),
                    Text(
                      "Username:\t",
                    ),
                    Text(
                      "UpMail:\t",
                    ),
                    Text(
                      "Student Number:\t",
                    ),

                    Text(
                      "Course:\t",
                    ),
                    Text(
                      "College:\t",
                    ),
                    Text(
                      "Status:\t",
                    ),
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //to display the value na align sa 1st column
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.uid}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.lastname}, ${u.firstname}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.username}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.email}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.studentNo}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.course}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.college}',
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${u.status}',
                      ),
                    ),
                  ]),
            ],
          ),
        ]),
      ),
    );
  }
}
