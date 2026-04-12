import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SignupController extends GetxController {
  var fullName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordVisible = false.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<bool> signup(String name, String email, String password, String confirmPassword) async {
    fullName.value = name;
    this.email.value = email;
    this.password.value = password;
    this.confirmPassword.value = confirmPassword;

    debugPrint("--- Signup Attempt ---");
    debugPrint("Name: $name");
    debugPrint("Email: $email");

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      debugPrint("Validation Error: Missing fields");
      Get.snackbar("Error", "All fields are required",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (!email.contains("@")) {
      debugPrint("Validation Error: Invalid email format");
      Get.snackbar("Error", "Invalid email format",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password != confirmPassword) {
      debugPrint("Validation Error: Passwords do not match");
      Get.snackbar("Error", "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.length < 6) {
      debugPrint("Validation Error: Password too short");
      Get.snackbar("Error", "Password must be at least 6 characters long",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    try {
      String url = kIsWeb ? 'http://localhost:3000/users' : 'http://10.0.2.2:3000/users';
      debugPrint("Connecting to: $url");

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'full_name': name,
          'email': email,
          'password': password,
        }),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Account created successfully!",
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("Error", data['message'] ?? 'Signup failed',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      debugPrint("Network Error: $e");
      Get.snackbar("Error", "Server connection failed: $e",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
