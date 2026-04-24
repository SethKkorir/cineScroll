import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'signup.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFBDC3C7), Color(0xFFEFF3F5)], // Clean grey gradient
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059', // Reliable Cinema Image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text("CineScroll", style: TextStyle(color: Color(0xFF2D3436), fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text(
                    "Discover the best movie trailers in a vertical scroll experience designed for cinema lovers.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  _button("Get Started", () => Get.to(() => const SignupScreen())),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    child: const Text("Already have an account? Sign In", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
