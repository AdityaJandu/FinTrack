import 'package:fin_track/components/bottom_nav_bar.dart';
import 'package:fin_track/screens/challenge_screen.dart';
import 'package:fin_track/screens/home_screen.dart';
import 'package:fin_track/screens/account_settings_screen.dart';
import 'package:fin_track/screens/transaction_screen.dart';
import 'package:fin_track/services/auth_services.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final AuthServices _authServices = AuthServices();

  int currentIndex = 0;

  var pageViewList = [
    const HomeScreen(),
    const ChallengeScreen(),
    const TransactionScreen(),
    const AccountSettingsScreen(),
  ];

  logOut() {
    _authServices.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageViewList[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(
            () {
              currentIndex = value;
            },
          );
        },
      ),
    );
  }
}
