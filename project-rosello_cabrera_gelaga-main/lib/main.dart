import 'package:final_project_app/providers/logs_provider.dart';
import 'package:final_project_app/screens/AddEntry.dart';
import 'package:final_project_app/screens/HomePage.dart';
import 'package:final_project_app/screens/ProfileAdmin.dart';
import 'package:final_project_app/screens/adminViewEdit.dart';
import 'package:final_project_app/screens/userProfile.dart';
import 'package:final_project_app/screens/adminVIewAll.dart';
import 'package:final_project_app/screens/adminViewDelete.dart';
import 'package:final_project_app/screens/adminViewQuarantined.dart';
import 'package:final_project_app/screens/adminViewUnderMonitoring.dart';
import 'package:final_project_app/screens/monitorScanner.dart';
import 'package:final_project_app/screens/userViewDeleteRequests.dart';
import 'package:final_project_app/screens/userViewEditRequests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login.dart';
import 'screens/monitorViewLogs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/entries_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => EntriesProvider())),
        ChangeNotifierProvider(create: ((context) => LogsProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth',
      initialRoute: '/login',
      theme: ThemeData.from(
          colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(255, 8, 68, 36),
        secondary: Color.fromARGB(255, 87, 29, 29),
      )).copyWith(
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                fontFamily: "LibreBaskerville"),
            titleLarge: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
                fontFamily: "LibreBaskerville"),
            titleMedium: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                fontFamily: "Roboto"),
            bodyLarge: TextStyle(fontFamily: "Roboto", fontSize: 18),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
          ),
          drawerTheme: const DrawerThemeData(
              backgroundColor: Color.fromARGB(255, 87, 29, 29)),
          listTileTheme: const ListTileThemeData(
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(0.5))))),
      routes: {
        '/login': (context) => const LoginPage(),
        '/userAddEntry': (context) => const AddEntry(),
        '/userView': (context) => const HomePage(),
        '/monitorView': (context) => const ViewLogs(),
        '/monitorScan': (context) => const QRScanner(),
        '/userProfile': (context) => const Profile(),
        '/adminProfile': (context) => const ProfileAdmin(),
        '/adminView': (context) => const AdminView(),
        '/viewQuarantine': (context) => const AdminViewQuarantined(),
        '/viewMonitored': (context) => const AdminViewMonitored(),
        '/viewEditEntries': (context) => const EditRequest(),
        '/viewDeleteEntries': (context) => const DeleteRequest(),
        '/userEditReqs': (context) => const UserEditRequests(),
        '/userDeleteReqs': (context) => const UserDeleteRequests()
      },
    );
  }
}
