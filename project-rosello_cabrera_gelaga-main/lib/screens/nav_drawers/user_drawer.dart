import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

Widget userDrawer() {
  List userViews = [
    'Home',
    'My Edit Requests',
    'My Delete Requests',
    'My Profile',
  ];
  List userRoutes = [
    '/userView',
    '/userEditReqs',
    '/userDeleteReqs',
    '/userProfile'
  ];

  List userIcons = [
    Icons.home_filled,
    Icons.edit_document,
    Icons.delete_forever,
    Icons.person
  ];
  return Drawer(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: userViews.length + 2, // +2 is for the sign out list tile
          itemBuilder: ((context, index) {
            if (index == 0) {
              return DrawerHeader(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary),
                  child: const Text(
                    "Navigation",
                    style: TextStyle(
                      fontFamily: "LibreBaskerville",
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 36,
                    ),
                  ));
            }
            if (index == userViews.length + 1) {
              return ListTile(
                title: Text(
                  "Sign Out",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                leading: const Icon(Icons.logout),
                onTap: () {
                  context.read<AuthProvider>().signOut;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              );
            }
            return ListTile(
              title: Text(
                userViews[index - 1],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              leading: Icon(userIcons[index - 1]),
              // Theme data is in main
              onTap: () => Navigator.pushReplacementNamed(
                  context, userRoutes[index - 1]),
            );
          })));
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});
  @override
  Widget build(context) {
    return userDrawer();
  }
}
