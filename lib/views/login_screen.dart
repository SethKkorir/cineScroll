import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/views/main_wrapper.dart';
import 'package:flutter_application_1/controllers/logincontroller.dart';
import 'package:get/get.dart';
import 'dart:ui';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        top: false, // Background images should usually go under the status bar
        child: Stack(
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
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildField("Email", usernameController, false),
                            const SizedBox(height: 20),
                            _buildField("Password", passwordController, true),
                            const SizedBox(height: 40),
                            Obx(() => GestureDetector(
                              onTap: loginController.isLoading.value ? null : () async {
                                bool success = await loginController.login(
                                  usernameController.text,
                                  passwordController.text,
                                );
                                if (success) Get.offAll(() => const MainWrapper());
                              },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: loginController.isLoading.value 
                                  ? const SizedBox(
                                      height: 20, 
                                      width: 20, 
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    )
                                  : const Text(
                                      "SIGN IN", 
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                    ),
                              ),
                            )),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text(
                                  "New here?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: () => Get.to(() => const SignupScreen()),
                                  child: const Text(
                                    "Sign up now",
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
            ),
          ],
        ),
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
