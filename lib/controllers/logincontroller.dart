import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var passwordVisible = false.obs;

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<bool> login(String user, String pass) async {
    username.value = user;
    password.value = pass;

    debugPrint("--- Login Attempt ---");
    debugPrint("Email: $user");

    if (user.isEmpty || pass.isEmpty) {
      debugPrint("Validation Error: Missing fields");
      Get.snackbar("Error", "All fields are required",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    try {
      String url = kIsWeb ? 'http://localhost:3000/login' : 'http://10.0.2.2:3000/login';
      debugPrint("Connecting to: $url");

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': user,
          'password': pass,
        }),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Login successful!",
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        final data = jsonDecode(response.body);
        debugPrint("Login Failed: ${data['message']}");
        Get.snackbar("Error", data['message'] ?? 'Login failed',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      debugPrint("Network Error: $e");
      Get.snackbar("Error", "Server connection failed",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
