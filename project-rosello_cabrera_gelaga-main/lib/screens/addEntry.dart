import 'package:final_project_app/models/firestore_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/entries_provider.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({super.key});

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
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

  bool? contact = false;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final AddButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          bool fever = _symptoms['Fever (37.8 C and above)']!;
          bool feelingFeverish = _symptoms['Feeling feverish']!;
          bool musclePain = _symptoms['Muscle or joint pains']!;
          bool cough = _symptoms['Cough']!;
          bool colds = _symptoms['Colds']!;
          bool soreThroat = _symptoms['Sore throat']!;

          bool difficultyBreathing = _symptoms['Difficulty of breathing']!;
          bool diarrhea = _symptoms['Diarrhea']!;
          bool lossOfSmell = _symptoms['Loss of smell']!;
          bool lossOfTaste = _symptoms['Loss of taste']!;
          bool recentContact =
              _symptoms['Contact with a confirmed COVID-19 case']!;
          bool none = false;

          final uid = context.read<AuthProvider>().currentUserUid;
          //  return uid;

          if (fever == false &&
              feelingFeverish == false &&
              musclePain == false &&
              cough == false &&
              colds == false &&
              soreThroat == false &&
              difficultyBreathing == false &&
              diarrhea == false &&
              lossOfSmell == false &&
              lossOfTaste == false &&
              recentContact == false) {
            none = true;
          }

          DateTime today = DateTime.now();
          String dateStr = "${today.day}-${today.month}-${today.year}";

          FirestoreEntry e = FirestoreEntry(
              none: none,
              fever: fever,
              feelingFeverish: feelingFeverish,
              musclePain: musclePain,
              cough: cough,
              colds: colds,
              soreThroat: soreThroat,
              difficultyBreathing: difficultyBreathing,
              diarrhea: diarrhea,
              lossOfTaste: lossOfTaste,
              lossOfSmell: lossOfSmell,
              recentContact: recentContact,
              entryId: '',
              entryDate: dateStr);

          context.read<EntriesProvider>().addEntry(e);
          if (recentContact == true) {
            context.read<AuthProvider>().editStatus("Monitoring", uid);
          } else if (none == true) {
            context.read<AuthProvider>().editStatus("Cleared", uid);
          } else if (none == false) {
            context.read<AuthProvider>().editStatus("With symptoms", uid);
          } //inject

          Navigator.pop(context); // go back to the previous page
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 130, 71, 71),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), // Background color
        ),
        child: const Text(
          'Add Entry',
          style: TextStyle(fontFamily: "LibreBaskerville"),
        ),
      ),
    );

    Widget showText(String text) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontFamily: "LibreBaskerville"),
        ),
      );
    }

    Widget check() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
              value: contact,
              onChanged: (bool? value) {
                setState(() {
                  contact = value!;
                });
              }),
          const Text("Yes",
              style: TextStyle(fontSize: 13, fontFamily: "LibreBaskerville")),
        ],
      );
    }

    Widget symptomsCheck() {
      List<String> symp = [];
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: _symptoms.length,
          itemBuilder: (BuildContext context, int index) {
            String key = _symptoms.keys.elementAt(index);

            return CheckboxListTile(
              value: _symptoms[key],
              onChanged: (bool? value) {
                setState(() {
                  _symptoms[key] = value!;
                });
                symp.add(key);
              },
              title: Text(key,
                  style: const TextStyle(
                      fontSize: 14, fontFamily: "LibreBaskerville")),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text("Add Entry",
                style: TextStyle(fontSize: 20, fontFamily: "LibreBaskerville")),
            backgroundColor: const Color.fromARGB(255, 149, 89, 89)),
        body: SingleChildScrollView(
            child: Center(
          child: Column(key: formKey, children: [
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                showText(
                  "Do you have any of the following symptoms?",
                ),
                symptomsCheck(),
                showText(
                    "Have you had any face-to-face contact with a confirmed COVID-19 case?"),
                check(),
                AddButton,
              ],
            )
          ]),
        )));
  }
}
