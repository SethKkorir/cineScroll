import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/movie_controller.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var userId = 0.obs; // Added to track user ID for watchlist
  var userName = "User".obs;
  var userEmail = "".obs;
  var userBio = "Cinema Lover 🍿".obs; // Added bio
  var profileUrl = "".obs; // Added profile URL
 
  final String baseUrl = "http://10.7.11.220:3000";

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showError('All fields are required');
      return false;
    }

    isLoading.value = true;
    debugPrint("Attempting login for: $email");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      isLoading.value = false;
      debugPrint("Server Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userEmail.value = email;
        
        // Handle nested user object from server
        if (data['user'] != null) {
          userId.value = data['user']['id'] ?? 0;
          userName.value = data['user']['fullName'] ?? data['user']['full_name'] ?? "User";
          userBio.value = data['user']['bio'] ?? "Cinema Lover 🍿";
          profileUrl.value = data['user']['profileUrl'] ?? "";
        }

        // --- NEW: Sync Watchlist after login ---
        try {
          final movieController = Get.find<MovieController>();
          movieController.fetchWatchlist();
        } catch (e) {
          debugPrint("MovieController not found yet: $e");
        }

        Get.snackbar('Success', 'Welcome back!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            margin: const EdgeInsets.all(20));
        return true;
      } else {
        _showError('Invalid email or password');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Connection Error: $e");
      _showError('Cannot connect to server at $baseUrl');
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('All fields are required');
      return false;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fullName': name, 'email': email, 'password': password}),
      );

      isLoading.value = false;

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Account created! Please sign in.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            margin: const EdgeInsets.all(20));
        return true;
      } else {
        _showError('Email might already be in use');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      _showError('Connection error');
      return false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Alert',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
      borderWidth: 1,
      borderColor: Colors.grey.withValues(alpha: 0.2),
      boxShadows: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
      ],
    );
  }
}
