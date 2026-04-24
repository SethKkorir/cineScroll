import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logincontroller.dart';
import 'main_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginController = Get.find<LoginController>();
  bool _isObscured = true; // State for password visibility

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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Text("WELCOME BACK", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.5)),
                const SizedBox(height: 60),

                _input(emailController, "e-mail"),
                _input(passwordController, "password", isPass: true),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.snackbar("Coming Soon", "Password recovery will be available soon!", 
                      backgroundColor: Colors.white70, colorText: Colors.black),
                    child: const Text("Forgot password?", style: TextStyle(color: Colors.grey, fontSize: 13))
                  ),
                ),

                const SizedBox(height: 10),
                const Text("Sign in with", style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 10),
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: IconButton(
                    onPressed: () => Get.snackbar("Coming Soon", "Google Sign-In will be available in the next update!", 
                      backgroundColor: Colors.white70, colorText: Colors.black),
                    icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 45)
                  ),
                ),

                const SizedBox(height: 40),
                _button("Sign in", () async {
                  bool success = await loginController.login(emailController.text, passwordController.text);
                  if (success) Get.offAll(() => const MainScreen());
                }),

                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text("New here? Create Account", style: TextStyle(color: Color(0xFF2D3436), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String hint, {bool isPass = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? _isObscured : false, // Apply visibility state
        style: const TextStyle(color: Colors.black, fontSize: 17),
        decoration: InputDecoration(
          hintText: hint, 
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          suffixIcon: isPass 
            ? IconButton(
                icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => _isObscured = !_isObscured), // Toggle state
              ) 
            : null,
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback action) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: ElevatedButton(
        onPressed: loginController.isLoading.value ? null : action,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: loginController.isLoading.value 
          ? const CircularProgressIndicator(color: Colors.white) 
          : Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    ));
  }
}
