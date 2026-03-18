import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login_screen.dart';
import 'package:flutter_application_1/views/main_wrapper.dart';
import 'package:flutter_application_1/views/home_feed_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen()),
        GetPage(name: "/main_wrapper", page: () => const MainWrapper()),
        GetPage(name: "/home_feed_screen", page: () => const HomeFeedScreen()),
      ],
    );
  }
}
