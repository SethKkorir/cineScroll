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
    final MovieController movieController = Get.find<MovieController>();

    final List<Widget> pages = [
      const HomeFeedScreen(),
      const DiscoverScreen(),
      const WatchlistScreen(),
      const ProfileScreen(),
    ];

    final List<String> titles = [
      "CINESCROLL",
      "DISCOVER",
      "WATCHLIST",
      "PROFILE",
    ];

    return Obx(() => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFBDC3C7), Color(0xFFEFF3F5)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let the gradient show through
        appBar: AppBar(
          title: Text(
            titles[movieController.currentTabIndex.value],
            style: const TextStyle(
              color: Colors.black, // Changed from Orange to Black
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 22,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: IndexedStack(
          index: movieController.currentTabIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: BottomNavigationBar(
            currentIndex: movieController.currentTabIndex.value,
            onTap: (index) => movieController.currentTabIndex.value = index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.movie_filter_outlined), activeIcon: Icon(Icons.movie_filter), label: "Feed"),
              BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: "Search"),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), activeIcon: Icon(Icons.bookmark), label: "Saved"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Me"),
            ],
          ),
        ),
      ),
    ));
  }
}
