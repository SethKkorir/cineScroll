import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signupcontroller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // 1. Cinematic Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF1E293B), Color(0xFF0F172A), Colors.black],
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
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header Section
                          const Icon(Icons.movie_creation_rounded, size: 70, color: Colors.blueAccent),
                          const SizedBox(height: 15),
                          const Text(
                            "Join CineScroll",
                            style: TextStyle(
                              fontSize: 30, 
                              fontWeight: FontWeight.w900, 
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Start your cinematic journey today",
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(height: 40),

                          // 2. Input Fields
                          _buildGlassInput(
                            controller: nameController,
                            hint: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 18),
                          
                          _buildGlassInput(
                            controller: emailController,
                            hint: "Email Address",
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 18),

                          Obx(() => _buildGlassInput(
                            controller: passwordController,
                            hint: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: !signupController.isPasswordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                signupController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () => signupController.togglePassword(),
                            ),
                          )),
                          const SizedBox(height: 18),

                          Obx(() => _buildGlassInput(
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            icon: Icons.lock_reset_outlined,
                            isPassword: true,
                            obscureText: !signupController.isPasswordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                signupController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () => signupController.togglePassword(),
                            ),
                          )),

                          const SizedBox(height: 40),

                          // 3. The Signup Button
                          GestureDetector(
                            onTap: () async {
                              bool isSuccess = await signupController.signup(
                                nameController.text,
                                emailController.text,
                                passwordController.text,
                                confirmPasswordController.text,
                              );
                              if (isSuccess) Get.back();
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
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already a member? ", style: TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.blueAccent, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
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

  // Consistent Glassmorphic Input UI
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
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.07),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.12)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ),
    );
  }
}