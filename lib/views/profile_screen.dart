import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logincontroller.dart';
import '../controllers/movie_controller.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final MovieController movieController = Get.find<MovieController>();

    return Scaffold(
      backgroundColor: Colors.white, // CHANGED TO WHITE
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // 1. AVATAR SECTION
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFF5F5F5),
                      child: Obx(() => Text(
                        loginController.userName.value.isNotEmpty 
                            ? loginController.userName.value[0].toUpperCase() 
                            : "U",
                        style: const TextStyle(fontSize: 40, color: Colors.orange, fontWeight: FontWeight.w900),
                      )),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2. NAME & BIO
            Obx(() => Text(
              loginController.userName.value.toUpperCase(),
              style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
            )),
            const SizedBox(height: 5),
            Obx(() => Text(
              loginController.userBio.value.isEmpty ? "Movie Enthusiast" : loginController.userBio.value,
              style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w500),
            )),
            
            const SizedBox(height: 35),

            // 3. STATS BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => _buildStat("SAVED", movieController.watchlist.length.toString())),
                  _buildStat("WATCHED", "12"),
                  _buildStat("RANK", "BRONZE"),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // 4. OPTIONS
            _buildOptionTile(Icons.edit_note_rounded, "Edit Profile", () {}),
            _buildOptionTile(Icons.history_rounded, "Watch History", () {}),
            _buildOptionTile(Icons.settings_suggest_outlined, "Preferences", () {}),
            _buildOptionTile(Icons.help_outline_rounded, "Support & Help", () {}),

            const SizedBox(height: 40),

            // 5. LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: OutlinedButton(
                onPressed: () {
                  loginController.userId.value = 0;
                  Get.offAll(() => const LoginScreen());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text("SIGN OUT", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value, 
          style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.w900)
        ),
        const SizedBox(height: 4),
        Text(
          label, 
          style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)
        ),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
      leading: Icon(icon, color: Colors.orange, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black.withOpacity(0.1), size: 14),
      onTap: onTap,
    );
  }
}
