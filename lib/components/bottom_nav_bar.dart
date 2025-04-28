import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {super.key,
      required this.currentIndex,
      required this.onDestinationSelected});

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onDestinationSelected,
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: Colors.purple,
        ),

        /// Likes
        SalomonBottomBarItem(
          icon: Image.asset(
            'assets/target.png',
            scale: 18,
          ),
          title: const Text("Challenge"),
          selectedColor: Colors.pink,
        ),

        /// Search
        SalomonBottomBarItem(
          icon: Image.asset(
            'assets/transaction.png',
            scale: 18,
          ),
          title: const Text("Transactions"),
          selectedColor: Colors.red,
        ),

        /// Profile
        SalomonBottomBarItem(
          icon: const Icon(CupertinoIcons.settings),
          title: const Text("Settings"),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}
