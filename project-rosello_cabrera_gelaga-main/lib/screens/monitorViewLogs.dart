import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_log_model.dart';
import 'package:final_project_app/screens/monitorSearchStudentLogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/logs_provider.dart';

import 'package:flutter/material.dart';

import './login.dart';
// import 'monitorScanner.dart';
import 'addEntry.dart';

class ViewLogs extends StatefulWidget {
  const ViewLogs({super.key});

  @override
  State<ViewLogs> createState() => _ViewLogsState();
}

class _ViewLogsState extends State<ViewLogs> {
  String location = "Main Library";
  bool _searchPressed = false;

  static final List<String> _locationOptions = [
    "Main Library",
    "Physical Sciences Building",
    "Student Union Building",
    "DL Umali",
    "CAS",
    "CAS Annex 1",
    "CAS Annex 2",
  ];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? logsStream = context.watch<LogsProvider>().log;
    late TextEditingController _searchController = TextEditingController();

    Widget locationDropdown() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: DropdownButtonFormField<String>(
          value: location,
          onChanged: (String? value) {
            setState(() {
              location =
                  value!; //store the value to the superpower key in summary map
            });
          },
          //for the items in the dropdown
          items: _locationOptions.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
      );
    }

    Widget _searchBar = TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Color.fromARGB(255, 149, 89, 89),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchStudentLogs(_searchController.text)));
            },
          ),
          suffixIconColor: Colors.white,
          hintText: "Enter a Student No...",
          hintStyle: TextStyle(color: Colors.white)),
    );

    Widget _searchTextField() {
      return TextField();
    }

    return Scaffold(
      appBar: AppBar(
        // title: !_searchPressed
        //     ? Text("Student Logs",
        //         style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville"))
        //     : _searchBar,
        title: !_searchPressed
            ? const Text(
                "Student Logs",
                style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville"),
              )
            : _searchBar,
        backgroundColor: const Color.fromARGB(255, 149, 89, 89),
        actions: [
          !_searchPressed
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/searchStudentLogs');
                    setState(() {
                      _searchPressed = true;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/searchStudentLogs');
                    setState(() {
                      _searchPressed = false;
                    });
                  },
                )
        ],
      ),
      drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 149, 89, 89),
          child: ListView(padding: EdgeInsets.zero, children: [
            const SizedBox(height: 150),
            ListTile(
              title: const Text('My Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "LibreBaskerville"),
                  textAlign: TextAlign.center),
              onTap: () async {
                // Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              title: const Text(
                'Add Entry',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "LibreBaskerville"),
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddEntry()));
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              title: const Text('Student Logs',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "LibreBaskerville"),
                  textAlign: TextAlign.center),
              onTap: () async {
                Navigator.pop(context);
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              title: const Text('Sign out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "LibreBaskerville"),
                  textAlign: TextAlign.center),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ])),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 149, 89, 89),
          child: const Icon(Icons.qr_code),
          onPressed: () {
            Navigator.pushNamed(context, '/monitorScan');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // body: const Center(
      //   child: Text("Logs"),
      // ),
      body: StreamBuilder(
          stream: logsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text("Error encountered! ${snapshot.error}"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No entries found!"),
              );
            }

            return Center(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Location:",
                      style: TextStyle(
                          fontSize: 18, fontFamily: "LibreBaskerville"),
                    ),
                    SizedBox(width: 300, child: locationDropdown())
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: ((context, index) {
                        FirestoreLog log = FirestoreLog.fromJson(
                            snapshot.data?.docs[index].data()
                                as Map<String, dynamic>);

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
                      })),
                ),
              ]),
            );
            // return ListView.builder(
            //     itemCount: snapshot.data?.docs.length,
            //     itemBuilder: ((context, index) {
            //       FirestoreLog log = FirestoreLog.fromJson(
            //           snapshot.data?.docs[index].data()
            //               as Map<String, dynamic>);

            //       return ListTile(
            //         title: Text("${log.studno}"),
            //       );
            //     }));
          }),
    );
  }
}
