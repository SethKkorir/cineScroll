import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/controllers/logincontroller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E293B), Colors.black],
              ),
            ),
          ),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Section
                          const Icon(Icons.movie_filter_rounded, size: 100, color: Colors.blueAccent),
                          const SizedBox(height: 10),
                          const Text(
                            "CineScroll",
                            style: TextStyle(
                              fontSize: 32, 
                              fontWeight: FontWeight.w900, 
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Text(
                            "Experience Cinema in Motion",
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(height: 50),

                          // 2. Glassmorphic Email Field
                          _buildGlassInput(
                            controller: usernameController,
                            hint: "Email Address",
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 20),

                          // 3. Glassmorphic Password Field
                          Obx(() => _buildGlassInput(
                            controller: passwordController,
                            hint: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: !loginController.passwordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.passwordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () => loginController.togglePassword(),
                            ),
                          )),

                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password?", style: TextStyle(color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 4. Modern Login Button
                          GestureDetector(
                            onTap: () async {
                              bool success = await loginController.login(
                                  usernameController.text, passwordController.text);
                              if (success) {
                                Get.offAllNamed("/main_wrapper");
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blueAccent, Colors.blue],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(33, 150, 243, 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              child: const Text(
                                "Log In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("New here? ", style: TextStyle(color: Colors.white70, fontSize: 16)),
                              GestureDetector(
                                onTap: () => Get.to(() => const SignupScreen()),
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.blueAccent, 
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for Glassmorphic Text Fields
  Widget _buildGlassInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}