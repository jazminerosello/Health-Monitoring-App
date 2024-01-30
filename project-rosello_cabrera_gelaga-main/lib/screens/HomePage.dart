import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_app/models/firestore_req_edit.dart';
import 'package:final_project_app/models/firestore_user_request.dart';
import 'package:final_project_app/providers/auth_provider.dart';
import 'package:final_project_app/providers/entries_provider.dart';
import 'package:final_project_app/screens/nav_drawers/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/firestore_entry_model.dart';
import 'AddEntry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool? contact = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> symp = [];

  static final Map<String, bool> _symptoms = {
    "Fever (37.8 C and above)": false,
    "Feeling feverish": false,
    "Muscle or joint pains": false,
    "Cough": false,
    "Colds": false,
    "Sore throat": false,
    "Difficulty of breathing": false,
    "Diarrhea": false,
    "Loss of taste": false,
    "Loss of smell": false,
    "Contact with a confirmed COVID-19 case": false
  };

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? entriesStream =
        context.watch<EntriesProvider>().entry;
    return Scaffold(
      drawer: userDrawer(),
      appBar: AppBar(
          title: const Text('My Entries',
              style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville")),
          backgroundColor: Theme.of(context).colorScheme.primary),
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
              child: Text("No entries found!"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              FirestoreEntry currentEntry = FirestoreEntry.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              currentEntry.entryId = snapshot.data!.docs[index].id;

              return ListTile(
                title: Text(currentEntry.entryDate.toString()),
                subtitle: Text(currentEntry.entryId),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Request to edit entry"),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: const Text(
                                                  "Do you have any of the following symptoms?",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "LibreBaskerville"),
                                                ),
                                              ),
                                              Column(
                                                children:
                                                    _symptoms.keys.map((key) {
                                                  return CheckboxListTile(
                                                    value: _symptoms[key],
                                                    onChanged: (bool? value) {
                                                      setState(() =>
                                                          _symptoms[key] =
                                                              value!);
                                                    },
                                                    title: Text(
                                                      key,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "LibreBaskerville"),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: const Text(
                                                  "Have you had any face-to-face contact with a confirmed COVID-19 case?",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "LibreBaskerville"),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Checkbox(
                                                      value: contact,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          contact = value!;
                                                        });
                                                      }),
                                                  const Text("Yes",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily:
                                                              "LibreBaskerville")),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    bool fever = _symptoms[
                                                        'Fever (37.8 C and above)']!;
                                                    bool feelingFeverish =
                                                        _symptoms[
                                                            'Feeling feverish']!;
                                                    bool musclePain = _symptoms[
                                                        'Muscle or joint pains']!;
                                                    bool cough =
                                                        _symptoms['Cough']!;
                                                    bool colds =
                                                        _symptoms['Colds']!;
                                                    bool soreThroat = _symptoms[
                                                        'Sore throat']!;

                                                    bool difficultyBreathing =
                                                        _symptoms[
                                                            'Difficulty of breathing']!;
                                                    bool diarrhea =
                                                        _symptoms['Diarrhea']!;
                                                    bool lossOfSmell =
                                                        _symptoms[
                                                            'Loss of smell']!;
                                                    bool lossOfTaste =
                                                        _symptoms[
                                                            'Loss of taste']!;
                                                    bool recentContact = _symptoms[
                                                        'Contact with a confirmed COVID-19 case']!;
                                                    bool none = false;

                                                    //  return uid;

                                                    if (fever == false &&
                                                        feelingFeverish ==
                                                            false &&
                                                        musclePain == false &&
                                                        cough == false &&
                                                        colds == false &&
                                                        soreThroat == false &&
                                                        difficultyBreathing ==
                                                            false &&
                                                        diarrhea == false &&
                                                        lossOfSmell == false &&
                                                        lossOfTaste == false &&
                                                        recentContact ==
                                                            false) {
                                                      none = true;
                                                    }

                                                    DateTime today =
                                                        DateTime.now();
                                                    String dateStr =
                                                        "${today.day}-${today.month}-${today.year}";
                                                    String currentUserUid =
                                                        context
                                                            .read<
                                                                AuthProvider>()
                                                            .currentUserUid;

                                                    FirestoreRequestEdit r =
                                                        FirestoreRequestEdit(
                                                            entryOwner:
                                                                currentUserUid,
                                                            none: none,
                                                            fever: fever,
                                                            feelingFeverish:
                                                                feelingFeverish,
                                                            musclePain:
                                                                musclePain,
                                                            cough: cough,
                                                            colds: colds,
                                                            soreThroat:
                                                                soreThroat,
                                                            difficultyBreathing:
                                                                difficultyBreathing,
                                                            diarrhea: diarrhea,
                                                            lossOfTaste:
                                                                lossOfTaste,
                                                            lossOfSmell:
                                                                lossOfSmell,
                                                            recentContact:
                                                                recentContact,
                                                            entryId:
                                                                currentEntry
                                                                    .entryId,
                                                            entryDate:
                                                                currentEntry
                                                                    .entryDate,
                                                            action: "Pending",
                                                            dateRequested:
                                                                dateStr,
                                                            dateApproved:
                                                                '00-00-0000');

                                                    context
                                                        .read<EntriesProvider>()
                                                        .editRequest(r);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 130, 71, 71),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ), // Background color
                                                  ),
                                                  child: const Text(
                                                    'Submit Entry',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "LibreBaskerville"),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                      },
                      icon: const Icon(Icons.create_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        DateTime today = DateTime.now();
                        String dateStr =
                            "${today.day}-${today.month}-${today.year}";
                        String uid =
                            context.read<AuthProvider>().currentUserUid;

                        FirestoreRequest r = FirestoreRequest(
                            entryOwner: uid,
                            entryId: currentEntry.entryId,
                            action: "Pending",
                            dateApproved: "00-00-00",
                            dateRequested: dateStr);

                        const AlertDialog(
                            title: Text("Successfully requested"));
                        context.read<EntriesProvider>().deleteRequest(r);
                      },
                      icon: const Icon(Icons.delete_outlined),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.mounted) {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const AddEntry())));
          }
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
  

  // }
