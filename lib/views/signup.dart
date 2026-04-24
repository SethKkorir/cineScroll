import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logincontroller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
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
                const Text("CREATE YOUR ACCOUNT", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.5)),
                const SizedBox(height: 60),

                _input(nameController, "full name"),
                _input(emailController, "e-mail"),
                _input(passwordController, "password", isPass: true),

                const SizedBox(height: 20),
                const Text("Sign up with", style: TextStyle(color: Colors.grey, fontSize: 13)),
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
                _button("Sign up", () async {
                  bool success = await loginController.signup(
                    nameController.text, 
                    emailController.text, 
                    passwordController.text
                  );
                  if (success) {
                    // Navigate to Login after success so they can sign in
                    Get.off(() => const LoginScreen());
                  }
                }),

                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => Get.to(() => const LoginScreen()),
                  child: const Text("Already have an account? Sign In", style: TextStyle(color: Color(0xFF2D3436), fontWeight: FontWeight.bold, fontSize: 16)),
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
