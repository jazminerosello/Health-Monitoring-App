import 'package:final_project_app/screens/signup_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/signup.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          //for validation na kapag empty may prompt message
          return 'Please enter valid email';
        } else if (EmailValidator.validate(emailController.text) == false) {
          //check if valid si email address
          return 'Please enter valid email';
        }
        return null;
      },
    );

    final password = TextFormField(
      key: const Key('pwField'),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          //for validation na kapag empty may prompt message
          return 'Please enter password atleast 6 characters';
        } else if (passwordController.text.length < 6) {
          //check lenght for password kasi need ay 6
          return 'Please enter password atleast 6 characters';
        }
        return null;
      },
    );

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            String currentUserPosition = "";
            //check the validaiton first
            formKey.currentState?.save();

            currentUserPosition = await context.read<AuthProvider>().signIn(
                  //call the method for signin
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

            if (context.mounted) {
              if (currentUserPosition == "admin") {
                //check if admin
                Navigator.pushNamed(context, '/adminView');
              } else if (currentUserPosition == "user") {
                //check if user
                Navigator.pushNamed(context, '/userView');
              } else if (currentUserPosition == "monitor") {
                Navigator.pushNamed(context, '/monitorView');
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 130, 71, 71),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), // Background color
        ),
        child: const Text('Log In',
            style:
                TextStyle(color: Colors.white, fontFamily: "LibreBaskerville")),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          return showDialog<void>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: const Text("What are you?",
                      style: TextStyle(fontFamily: "LibreBaskerville")),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminSignupPage('admin')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 130, 71, 71),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ), // Background color
                          ),
                          child: const Text('Admin',
                              style:
                                  TextStyle(fontFamily: "LibreBaskerville"))),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 130, 71, 71),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ), // Background color
                          ),
                          child: const Text('User/Monitor',
                              style:
                                  TextStyle(fontFamily: "LibreBaskerville"))),
                    ],
                  )));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 130, 71, 71),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), // Background color
        ),
        child: const Text('Sign Up',
            style:
                TextStyle(color: Colors.white, fontFamily: "LibreBaskerville")),
      ),
    );

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 254, 254),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 144, 86, 86),
                    fontFamily: "LibreBaskerville"),
              ),
              Form(
                  //ilagay sa form para sa validaiton
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      email,
                      password,
                      loginButton,
                      signUpButton,
                    ],
                  ))
            ],
          ),
        ));
  }
}
