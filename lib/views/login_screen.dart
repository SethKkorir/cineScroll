import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/views/main_wrapper.dart';
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
      backgroundColor: const Color(0xFF0B0B0C),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildField("Email", usernameController, Icons.email, false),
                const SizedBox(height: 20),
                _buildField("Password", passwordController, Icons.lock, true),
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
                      color: const Color(0xFF05FFD1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: loginController.isLoading.value 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                        )
                      : const Text("LOGIN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                )),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF05FFD1))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, bool isPass) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
