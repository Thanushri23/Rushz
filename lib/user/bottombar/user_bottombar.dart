import 'package:flutter/material.dart';
import 'package:rushz/user/bookings/user_bookings.dart';
import 'package:rushz/user/home/user_home.dart';
import 'package:rushz/user/settings/user_profile.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key, required UserHome child});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    UserHome(),
    Bookings(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Animated switching between tabs
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _screens[_currentIndex],
      ),

      // Modern styled Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green[600],
            unselectedItemColor: Colors.grey[500],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),

            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 1
                      ? Icons.confirmation_num
                      : Icons.confirmation_num_outlined,
                ),
                label: "Bookings",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 2 ? Icons.person : Icons.person_outline,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
