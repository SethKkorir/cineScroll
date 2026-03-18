import 'package:get/get.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var passwordVisible = false.obs;

  bool login(String user, String pass) {
    username.value = user;
    password.value = pass;
    if (username.value == "admin" && password.value == "123456") {
      return true;
    } else {
      return false;
    }
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
