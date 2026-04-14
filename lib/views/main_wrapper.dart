import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home_feed_screen.dart';
import 'package:flutter_application_1/views/discover_screen.dart';
import 'package:flutter_application_1/views/watchlist_screen.dart';
import 'package:flutter_application_1/views/profile_screen.dart';
import 'dart:ui';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeFeedScreen(),
    const DiscoverScreen(),
    const WatchlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This allows the body to go behind the blurred nav bar
      backgroundColor: Colors.black,
      body: _screens[_currentIndex],
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.movie_filter_outlined, 'active': Icons.movie_filter, 'label': 'Feed'},
      {'icon': Icons.explore_outlined, 'active': Icons.explore, 'label': 'Discover'},
      {'icon': Icons.bookmark_border, 'active': Icons.bookmark, 'label': 'Watchlist'},
      {'icon': Icons.person_outline, 'active': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: SafeArea(
        top: false,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 70, // Reduced slightly for better safe area balance
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final bool isActive = currentIndex == index;
                  return GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? items[index]['active'] as IconData : items[index]['icon'] as IconData,
                          color: isActive ? Colors.orange : Colors.white.withValues(alpha: 0.6),
                          size: 24, // Consistent pro sizing
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[index]['label'] as String,
                          style: TextStyle(
                            color: isActive ? Colors.orange : Colors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: isActive ? 10 : 0,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
