import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

Widget adminDrawer() {
  List adminViews = [
    'Home',
    'View All Edit Requests',
    'View All Delete Requests',
    'View Monitored Users',
    'View Users Under Quarantine',
    'My Profile',
  ];
  List adminRoutes = [
    '/adminView',
    '/viewEditEntries',
    '/viewDeleteEntries',
    '/viewMonitored',
    '/viewQuarantine',
    '/adminProfile'
  ];

  List adminIcons = [
    Icons.home_filled,
    Icons.edit_document,
    Icons.delete_forever,
    Icons.monitor_heart,
    Icons.masks,
    Icons.person
  ];
  return Drawer(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: adminViews.length + 2, // +2 is for the sign out list tile
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
            if (index == adminViews.length + 1) {
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
                adminViews[index - 1],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              leading: Icon(adminIcons[index - 1]),
              // Theme data is in main
              onTap: () => Navigator.pushReplacementNamed(
                  context, adminRoutes[index - 1]),
            );
          })));
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});
  @override
  Widget build(context) {
    return adminDrawer();
  }
}
