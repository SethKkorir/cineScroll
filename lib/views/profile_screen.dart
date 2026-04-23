import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logincontroller.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("PROFILE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // User Avatar
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange,
              child: Obx(() => Text(
                loginController.userName.value[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          const SizedBox(height: 15),
          Obx(() => Text(
            loginController.userName.value,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          )),
          Obx(() => Text(
            loginController.userEmail.value,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          )),
          const SizedBox(height: 30),

          // Profile Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat("Watchlist", "12"),
              _buildStat("Reviews", "0"),
              _buildStat("Points", "500"),
            ],
          ),
          const SizedBox(height: 40),

          // Profile Options
          _buildOption(Icons.history, "Watch History"),
          _buildOption(Icons.notifications_outlined, "Notifications"),
          _buildOption(Icons.security, "Security Settings"),
          _buildOption(Icons.help_outline, "Help & Support"),
          
          const Spacer(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => const LoginScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("SIGN OUT", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 24),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      onTap: () {},
    );
  }
}
