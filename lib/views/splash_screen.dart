import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds then go to Onboarding (8 was too long)
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const OnboardingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFBDC3C7), Color(0xFFEFF3F5)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FLOATING LOGO
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const Icon(
                Icons.movie_filter_rounded,
                size: 80,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "CINESCROLL",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 35,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Grounded Cinema".toUpperCase(),
              style: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(color: Colors.orange, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
