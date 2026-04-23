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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController(), permanent: true);
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Subtle Textured Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2059',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'CINE SCROLL',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(height: 2, width: 40, color: Colors.orange.withOpacity(0.5)),
                    const SizedBox(height: 60),

                    // Inputs
                    _buildInputField(emailController, 'EMAIL ADDRESS', Icons.email_outlined),
                    const SizedBox(height: 15),
                    _buildInputField(
                      passwordController, 
                      'PASSWORD', 
                      Icons.lock_open_rounded, 
                      isPassword: true
                    ),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showComingSoon("Forgot Password"),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

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
                                  Get.offAll(() => const MainScreen());
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          elevation: 0,
                        ),
                        child: loginController.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text('LOG IN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
                      ),
                    )),

                    const SizedBox(height: 40),

                    // Google Login
                    OutlinedButton.icon(
                      onPressed: () => _showComingSoon("Google Login"),
                      icon: const Icon(Icons.g_mobiledata, size: 30),
                      label: const Text("CONTINUE WITH GOOGLE"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Signup Prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New to CineScroll? ", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
                        GestureDetector(
                          onTap: () => Get.to(() => const SignupScreen()),
                          child: const Text(
                            "JOIN NOW", 
                            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange.withOpacity(0.4), size: 20),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white24, size: 20),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ) : null,
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      "Alert",
      "$feature coming soon.",
      backgroundColor: Colors.white,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 4,
    );
  }
}
