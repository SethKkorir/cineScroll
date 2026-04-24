import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/splash_screen.dart';
import 'controllers/logincontroller.dart';
import 'controllers/movie_controller.dart';

void main() {
  // We initialize our logic controllers right at the start
  // This makes sure our Login and Movie data is ready for the whole app
  Get.put(LoginController(), permanent: true);
  Get.put(MovieController(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp is used instead of MaterialApp to use GetX features
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CINESCROLL',
      
      // Our App's Style: Dark Theme with Orange Accents
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        
        colorScheme: const ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.orangeAccent,
          surface: Colors.black,
        ),
        
        // This makes all our top bars look clean and black
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      
      // The very first screen of the app
      home: const SplashScreen(),
    );
  }
}
