import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;

    // Simulate network delay for testing
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;

    // Test credentials: seth / 123
    if (email == 'seth' && password == '123') {
      Get.snackbar('Welcome back!', 'Login successful (Test Mode)',
          snackPosition: SnackPosition.BOTTOM);
      return true;
    } else {
      Get.snackbar('Error', 'Invalid credentials. Use seth/123 for testing.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    /*
    // REAL BACKEND LOGIN CODE (Commented out for testing)
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
    */
  }
}
