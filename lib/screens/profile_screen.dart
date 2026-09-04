import 'package:flutter/material.dart';

import 'memory_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 25),
          const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 45)),
          const SizedBox(height: 12),
          const Center(child: Text('MAX User', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.psychology_alt),
            title: const Text('MAX Memory'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemoryScreen())),
          ),
          const ListTile(leading: Icon(Icons.history), title: Text('Chat History'), trailing: Icon(Icons.chevron_right)),
          const ListTile(leading: Icon(Icons.workspace_premium), title: Text('MAX Ultra'), trailing: Icon(Icons.chevron_right)),
          const ListTile(leading: Icon(Icons.info_outline), title: Text('About MAX'), trailing: Icon(Icons.chevron_right)),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
