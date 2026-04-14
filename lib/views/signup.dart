import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login_screen.dart';
import 'package:flutter_application_1/controllers/logincontroller.dart';
import 'package:get/get.dart';
import 'dart:ui';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
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
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start Your Journey",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildField("Full Name", nameController),
                            const SizedBox(height: 20),
                            _buildField("Email", emailController),
                            const SizedBox(height: 20),
                            _buildPasswordField("Password", passwordController),
                            const SizedBox(height: 30),
                            Obx(() => GestureDetector(
                              onTap: loginController.isLoading.value ? null : () async {
                                bool success = await loginController.signup(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );
                                if (success) Get.offAll(() => const LoginScreen());
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
                                      "CREATE ACCOUNT", 
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                    ),
                              ),
                            )),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                "OR SIGN UP WITH",
                                style: TextStyle(color: Colors.black38, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                _socialButton("Google", Icons.g_mobiledata),
                                const SizedBox(width: 15),
                                _socialButton("Facebook", Icons.facebook),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already a member?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: () => Get.to(() => const LoginScreen()),
                                  child: const Text(
                                    "Sign in here",
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

  Widget _buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _isPasswordObscured,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.orange,
          ),
          onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
        ),
      ),
    );
  }

  Widget _socialButton(String label, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.snackbar(
          "Coming Soon", 
          "$label signup is not available yet.",
          backgroundColor: Colors.white,
          colorText: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
