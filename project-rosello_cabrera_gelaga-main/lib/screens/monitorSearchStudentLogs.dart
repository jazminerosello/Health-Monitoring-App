import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/logs_provider.dart';
import 'package:final_project_app/models/firestore_log_model.dart';

class SearchStudentLogs extends StatefulWidget {
  final String _searchValue;
  const SearchStudentLogs(this._searchValue, {super.key});

  @override
  State<SearchStudentLogs> createState() => _SearchStudentLogsState();
}

class _SearchStudentLogsState extends State<SearchStudentLogs> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? studentLogs =
        context.watch<LogsProvider>().studentLogs(widget._searchValue);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 149, 89, 89),
          title: Text("${widget._searchValue}'s Logs")),
      body: StreamBuilder(
        stream: studentLogs,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error encountered! ${snapshot.error}"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No entries found!"),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                FirestoreLog log = FirestoreLog.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);

                return ListTile(
                    title: Text("${log.studno}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Entered ${log.location}"),
                        Text("${log.status}"),
                        Text("${log.logDate}")
                      ],
                    ));
              }));
        },
      ),
    );
  }
}
