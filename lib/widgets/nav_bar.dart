import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar(
      {super.key,
      required this.selectedIndex,
      required this.onDestinationSelected});

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.explore),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.computer),
          label: 'Challenge',
        ),
        NavigationDestination(
          icon: Icon(Icons.commute),
          label: 'Tranctions',
        ),
      ],
    );
  }
}
