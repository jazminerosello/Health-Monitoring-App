import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/firestore_user_model.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String college = "College of Arts and Sciences";
  List<String> ill = [];
  int num = 0;

  static final List<String> _dropdownOptions = [
    "College of Arts and Sciences",
    "College of Agriculture and Food Science",
    "College of Development Communication",
    "College of Economics and Management",
    "College of Engineering and Agro-industrial Technology",
    "College of Forestry and Natural Resources",
    "College of Human Ecology",
    "College of Vetenary Medicine",
  ];

  static final Map<String, bool> _illness = {
    "Hypertension": false,
    "Diabetes": false,
    "Tubercolosis": false,
    "Cancer": false,
    "Kidney Disease": false,
    "Autoimmune Disease": false,
    "Asthma": false
  };

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _userNameController;
  late TextEditingController _courseController;
  late TextEditingController _studnoController;
  late TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _userNameController = TextEditingController();
    _courseController = TextEditingController();
    _firstnameController = TextEditingController();
    _studnoController = TextEditingController();
    _otherController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final firstname = TextFormField(
      controller: _firstnameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
      validator: (value) => value!.isEmpty ? 'Full Name' : null,
    );

    final lastname = TextFormField(
      controller: _lastnameController,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
      validator: (value) => value!.isEmpty ? 'Full Name' : null,
    );

    final userName = TextFormField(
      controller: _userNameController,
      decoration: const InputDecoration(
        hintText: "Username",
      ),
      validator: (value) => value!.isEmpty ? 'Enter username' : null,
    );

    final email = TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      validator: (value) {
        RegExp regex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (value!.isEmpty) {
          return 'Enter Email';
        } else if (regex.hasMatch(value) == false) {
          return 'Enter Valid Email';
        } else {
          return null;
        }
      },
    );

    final password = TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) =>
          value!.length < 6 ? 'Password has to be 6 characters long' : null,
    );

    Widget drop() {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField<String>(
          value: college,
          onChanged: (String? value) {
            setState(() {
              college =
                  value!; //store the value to the superpower key in summary map
            });
          },
          //for the items in the dropdown
          items: _dropdownOptions.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          //for onSaved, store the newValue to the summary superpower key
          onSaved: (newValue) {
            college = newValue.toString();
          },
        ),
      );
    }


    final course = TextFormField(
        controller: _courseController,
        decoration: const InputDecoration(
          hintText: 'Course',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter course';
          } else {
            return null;
          }
        });

    final studno = TextFormField(
        controller: _studnoController,
        decoration: const InputDecoration(
          hintText: 'Student Number',
        ),
        keyboardType: TextInputType
            .number, //to limit and make sure that user will input numbers only
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (String value) {
          num = int.parse(value);
        },
        validator: (value) {
          // RegExp regex = RegExp(r"^[0-9]+[-]+[0-9]");
          if (value!.isEmpty) {
            return 'Enter Student Number';
          }
          // else if (regex.hasMatch(value) == false) {
          //   return 'Enter Student Number';
          // }
          return null;
        });

    final others = TextFormField(
      controller: _otherController,
      decoration: const InputDecoration(
        hintText: 'If Allergies, please specify',
      ),
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (_otherController.text != "") {
              ill.add(_otherController.text);
            }
            final newUser = FirestoreUser.fromJson({
              'uid': "0",
              'username': _userNameController.text.toString(),
              'firstname': _firstnameController.text.toString(),
              'lastname': _lastnameController.text.toString(),
              'college': college,
              'course': _courseController.text.toString(),
              'email': _emailController.text.toString(),
              'studentNo': num.toString(),
              'illness': ill,
              "status": 'No Entry',
            });

            context.read<AuthProvider>().signUpUser(
                _emailController.text, _passwordController.text, newUser);
            ill = [];
            if (context.mounted) Navigator.pushNamed(context, '/');
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 130, 71, 71),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), // Background color
        ),
        child: const Text('Sign up',
            style:
                TextStyle(color: Colors.white, fontFamily: "LibreBaskerville")),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 130, 71, 71),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), // Background color
        ),
        child: const Text('Back',
            style:
                TextStyle(color: Colors.white, fontFamily: "LibreBaskerville")),
      ),
    );

    Widget illness() {
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: _illness.length,
          itemBuilder: (BuildContext context, int index) {
            String key = _illness.keys.elementAt(index);

            return CheckboxListTile(
              value: _illness[key],
              onChanged: (bool? value) {
                setState(() {
                  _illness[key] = value!;
                  // ill!.add(key);
                });
                ill.add(key);
              },
              title: Text(key),
            );
          });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  const Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25, fontFamily: "LibreBaskerville"),
                  ),
                  email,
                  password,
                  firstname,
                  lastname,
                  userName,
                  drop(),
                  course,
                  studno,
                  illness(),
                  others,
                  SignupButton,
                  backButton
                ],
              )),
        ));
  }
}
