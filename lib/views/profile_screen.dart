import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: const Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Seth Korir",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "kipseth@gmaill.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(height: 40),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Account Settings"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & Support"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
          Divider(),
        ],
      ),
    );
  }
}