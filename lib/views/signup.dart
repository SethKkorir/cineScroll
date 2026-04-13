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
      backgroundColor: const Color(0xFF0B0B0C),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildField("Full Name", nameController, Icons.person, false),
                const SizedBox(height: 20),
                _buildField("Email", emailController, Icons.email, false),
                const SizedBox(height: 20),
                _buildField("Password", passwordController, Icons.lock, true),
                const SizedBox(height: 20),
                _buildField("Confirm Password", confirmPasswordController, Icons.lock_outline, true),
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
                      color: const Color(0xFF05FFD1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: signupController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                        )
                      : const Text("CREATE ACCOUNT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                )),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Already have an account? Log In", style: TextStyle(color: Color(0xFF05FFD1))),
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
