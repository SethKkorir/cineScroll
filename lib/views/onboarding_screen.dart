import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'signup.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (Rugged/Cinematic)
          Positioned.fill(
            child: Opacity(
              opacity: 0.7, 
              child: Image.network(
                'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2025',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. GRADIENT OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 0.9],
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 3. CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // BRANDING
                  Column(
                    children: [
                      const Text(
                        "CINE SCROLL",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(height: 2, width: 30, color: Colors.orange),
                    ],
                  ),
                  
                  const Spacer(),

                  // MAIN TEXT
                  const Text(
                    "FIND IT FAST.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Stop searching.\nStart scrolling.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 60),

                  // GET STARTED BUTTON
                  GestureDetector(
                    onTap: () => Get.to(() => const SignupScreen()),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "GET STARTED",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),

                  // SIGN IN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ALREADY A MEMBER? ",
                        style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const LoginScreen()),
                        child: const Text(
                          "SIGN IN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
