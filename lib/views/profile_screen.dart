import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Seth Korir",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text(
                "kipseth@gmaill.com",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Account Settings"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.help), 
              title: Text("Help & Support"),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Get.offAllNamed("/");
              },
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
