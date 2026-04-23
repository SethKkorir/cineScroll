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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("MY PROFILE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 1. AVATAR SECTION
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.orange,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.black,
                      child: Obx(() => Text(
                        loginController.userName.value.isNotEmpty 
                            ? loginController.userName.value[0].toUpperCase() 
                            : "U",
                        style: const TextStyle(fontSize: 40, color: Colors.orange, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2. NAME & BIO
            Obx(() => Text(
              loginController.userName.value,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 5),
            Obx(() => Text(
              loginController.userBio.value,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic),
            )),
            
            const SizedBox(height: 30),

            // 3. STATS BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Correctly wrap the saved count in Obx
                  Obx(() => _buildStat("Saved", movieController.watchlist.length.toString())),
                  _buildStat("Watched", "0"),
                  _buildStat("Points", "100"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. OPTIONS
            _buildSimpleOption(Icons.bookmark_outline, "My Watchlist", () {
              // Navigation to watchlist tab could go here
            }),
            _buildSimpleOption(Icons.history, "Watch History", () {}),
            _buildSimpleOption(Icons.settings_outlined, "Settings", () {}),
            _buildSimpleOption(Icons.info_outline, "About Cinescroll", () {}),

            const SizedBox(height: 40),

            // 5. LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    loginController.userId.value = 0; // Clear user session
                    Get.offAll(() => const LoginScreen());
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  child: const Text("LOG OUT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Simple helper without Obx inside it
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value, 
          style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildSimpleOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: onTap,
    );
  }
}
