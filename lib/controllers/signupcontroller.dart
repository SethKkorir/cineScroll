import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  Future<bool> signup(String name, String email, String password, String confirm) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (!email.contains('@')) {
      Get.snackbar('Error', 'Enter a valid email',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password != confirm) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'full_name': name, 'email': email, 'password': password}),
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Account created!',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Signup failed',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Signup error: $e');
      Get.snackbar('Error', 'Could not connect to server',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
