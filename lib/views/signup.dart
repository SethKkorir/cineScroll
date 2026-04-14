import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signupcontroller.dart';
import 'dart:ui';

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
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=2070',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white, // Changed from Dark to White
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.black, // Dark text
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildField("Full Name", nameController, false),
                        const SizedBox(height: 20),
                        _buildField("Email", emailController, false),
                        const SizedBox(height: 20),
                        _buildField("Password", passwordController, true),
                        const SizedBox(height: 20),
                        _buildField("Confirm Password", confirmPasswordController, true),
                        const SizedBox(height: 40),
                        Obx(() => GestureDetector(
                          onTap: signupController.isLoading.value ? null : () async {
                            bool success = await signupController.signup(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              confirmPasswordController.text,
                            );
                            if (success) Get.back();
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.orange, // Orange button
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: signupController.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                )
                              : const Text(
                                  "CREATE ACCOUNT", 
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                          ),
                        )),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool isPass) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
