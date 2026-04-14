import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logincontroller.dart';
import 'home_feed_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Solid Black instead of image/blur
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CINESCROLL',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'REDEFINING CINEMA FEED',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Email Field
                _buildTextField(emailController, 'EMAIL ADDRESS', Icons.alternate_email),
                const SizedBox(height: 20),
                
                // Password Field
                _buildTextField(
                  passwordController, 
                  'PASSWORD', 
                  Icons.lock_outline, 
                  isPassword: true
                ),
                
                const SizedBox(height: 40),

                // Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loginController.isLoading.value
                        ? null
                        : () async {
                            bool success = await loginController.login(
                                emailController.text, passwordController.text);
                            if (success) {
                              Get.offAll(() => const HomeFeedScreen());
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                    ),
                    child: loginController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('LOG IN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                )),

                const SizedBox(height: 20),

                // Social Logins
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white24)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("OR JOIN WITH", style: TextStyle(color: Colors.white38, fontSize: 10)),
                    ),
                    const Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Google Sign In (The reference button)
                GestureDetector(
                  onTap: () => _showComingSoon("Google Login"),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata, color: Colors.black, size: 35),
                        const SizedBox(width: 10),
                        const Text("GOOGLE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("NOT A MEMBER?", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    TextButton(
                      onPressed: () => Get.to(() => const SignupScreen()),
                      child: const Text("SIGN UP NOW", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white54, size: 20),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white54, size: 20),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ) : null,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      "Alert",
      "$feature is currently being prepared for CINESCROLL.",
      backgroundColor: Colors.white,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 2),
      borderWidth: 1,
      borderColor: Colors.grey.withValues(alpha: 0.1),
      boxShadows: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
      ],
    );
  }
}
