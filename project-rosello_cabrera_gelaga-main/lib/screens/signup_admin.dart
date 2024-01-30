import 'package:final_project_app/models/firestore_monitor_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/firestore_admin_model.dart';
import '../providers/auth_provider.dart';

class AdminSignupPage extends StatefulWidget {
  final String
      pos; //need this to check if the one signing up is a user or an admin, since they basically have the same model
  const AdminSignupPage(this.pos, {super.key});
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController employeeNoController = TextEditingController();
    TextEditingController homeUnitController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final email = TextFormField(
      controller: emailController,
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
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) =>
          value!.length < 6 ? 'Password has to be 6 characters long' : null,
    );

    final firstName = TextFormField(
      controller: firstNameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
      validator: (value) => value!.isEmpty ? 'Enter First Name' : null,
    );

    final lastName = TextFormField(
      controller: lastNameController,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
      validator: (value) => value!.isEmpty ? 'Enter Last Name' : null,
    );

    final employeeNo = TextFormField(
      controller: employeeNoController,
      decoration: const InputDecoration(
        hintText: "Employee Number",
      ),
      validator: (value) => value!.isEmpty ? 'Enter Employee Number' : null,
    );

    final homeUnit = TextFormField(
      controller: homeUnitController,
      decoration: const InputDecoration(
        hintText: "Home Unit",
      ),
      validator: (value) => value!.isEmpty ? 'Enter Home Unit' : null,
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (widget.pos == 'admin') {
              final newAdmin = FirestoreAdmin.fromJson({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'email': emailController.text,
                'employeeNum': employeeNoController.text,
                'homeUnit': homeUnitController.text,
                'uid': '',
                'position': 'Admin'
              });
              await context.read<AuthProvider>().SignUpAdmin(
                  emailController.text, passwordController.text, newAdmin);
              if (context.mounted) {
                Navigator.pushNamed(context, '/adminView');
              }
            }
            if (widget.pos == 'monitor') {
              final newMonitor = FirestoreMonitor.fromJson({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'email': emailController.text,
                'employeeNum': employeeNoController.text,
                'homeUnit': homeUnitController.text,
                'uid': '',
                'position': 'Monitor'
              });
              await context.read<AuthProvider>().SignUpMonitor(
                  emailController.text, passwordController.text, newMonitor);

              if (context.mounted) {
                Navigator.pushNamed(context, '/adminView');
              }

              //show snackbar: "New Monitor Account created!"
            }
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
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 144, 86, 86),
                        fontFamily: "LibreBaskerville"),
                  ),
                  email,
                  password,
                  firstName,
                  lastName,
                  employeeNo,
                  homeUnit,
                  SignupButton,
                  backButton
                ],
              )),
        ));
  }
}
