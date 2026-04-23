import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import 'home_feed_screen.dart';
import 'watchlist_screen.dart';
import 'discover_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This finds the controller we created earlier
    final MovieController movieController = Get.find<MovieController>();

    // The list of screens for each tab
    final List<Widget> pages = [
      const HomeFeedScreen(),
      const DiscoverScreen(),
      const WatchlistScreen(),
      const ProfileScreen(),
    ];

    // The titles for the top bar
    final List<String> titles = [
      "CINESCROLL",
      "DISCOVER",
      "WATCHLIST",
      "PROFILE",
    ];

    return Obx(() => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          titles[movieController.currentTabIndex.value],
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.05), height: 1),
        ),
      ),
      body: IndexedStack(
        index: movieController.currentTabIndex.value,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: movieController.currentTabIndex.value,
        onTap: (index) {
          movieController.currentTabIndex.value = index;
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white24,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "DISCOVER"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: "SAVED"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "PROFILE"),
        ],
      ),
    ));
  }
}
