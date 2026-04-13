import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        Get.snackbar('Welcome back!', 'Login successful',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Login failed',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Login error: $e');
      Get.snackbar('Error', 'Could not connect to server',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
