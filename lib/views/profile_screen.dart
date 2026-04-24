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
      backgroundColor: Colors.transparent, // Let gradient show
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // 1. AVATAR SECTION
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFF5F5F5),
                      child: Obx(() => Text(
                        loginController.userName.value.isNotEmpty 
                            ? loginController.userName.value[0].toUpperCase() 
                            : "U",
                        style: const TextStyle(fontSize: 45, color: Colors.orange, fontWeight: FontWeight.w900),
                      )),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange, 
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10)],
                      ),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2. NAME & BIO
            Obx(() => Text(
              loginController.userName.value.toUpperCase(),
              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            )),
            const SizedBox(height: 5),
            Obx(() => Text(
              loginController.userBio.value.isEmpty ? "Movie Enthusiast" : loginController.userBio.value,
              style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
            )),
            
            const SizedBox(height: 35),

            // 3. STATS CARD (Floating)
            _cardWrapper(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => _buildStat("SAVED", movieController.watchlist.length.toString())),
                  _buildStat("WATCHED", "12"),
                  _buildStat("RANK", "GOLD"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. OPTIONS CARD
            _cardWrapper(
              child: Column(
                children: [
                  _buildOptionTile(Icons.edit_note_rounded, "Edit Profile", () => Get.snackbar("Coming Soon", "Profile editing will be available soon!")),
                  const Divider(height: 1),
                  _buildOptionTile(Icons.history_rounded, "Watch History", () => Get.snackbar("Coming Soon", "Viewing history is coming soon!")),
                  const Divider(height: 1),
                  _buildOptionTile(Icons.settings_suggest_outlined, "Preferences", () => Get.snackbar("Coming Soon", "Preferences will be available soon!")),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 5. LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  loginController.userId.value = 0;
                  Get.offAll(() => const LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                child: const Text("SIGN OUT", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // Floating Card Helper
  Widget _cardWrapper({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value, 
          style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.w900)
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
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.orange, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Color(0xFF2D3436), fontSize: 15, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 14),
      onTap: onTap,
    );
  }
}
