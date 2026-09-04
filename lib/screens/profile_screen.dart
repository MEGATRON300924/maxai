import 'package:flutter/material.dart';

import '../memory/memory_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: ListView(

        children: [

          const SizedBox(height: 25),

          const CircleAvatar(
            radius: 48,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              "MAX User",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.psychology_alt),
            title: const Text("MAX Memory"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MemoryScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Chat History"),
            trailing: const Icon(Icons.chevron_right),
          ),

          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text("MAX Ultra"),
            trailing: const Icon(Icons.chevron_right),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About MAX"),
            trailing: const Icon(Icons.chevron_right),
          ),

          const SizedBox(height: 50),

        ],
      ),
    );
  }
}