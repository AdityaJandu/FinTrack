import 'package:fin_track/components/profile_menu_items.dart';
import 'package:fin_track/main.dart';
import 'package:fin_track/screens/challenge_screen.dart';
import 'package:fin_track/screens/profile_screen.dart';
import 'package:fin_track/screens/transaction_screen.dart';
import 'package:fin_track/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final AuthServices _authServices = AuthServices();

  logOut() {
    _authServices.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Account Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: mq.width * 0.12),
            const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://i.pinimg.com/736x/50/a1/4c/50a14c55cb0563883cf971f206e84fdf.jpg",
              ),
              radius: 75,
            ),
            SizedBox(height: mq.width * 0.1),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              ),
              child: const ProfileMenuItems(
                description: 'My Profile',
                prefixIcon: CupertinoIcons.person,
              ),
            ),
            SizedBox(height: mq.width * 0.04),
            const ProfileMenuItems(
              description: 'Settings',
              prefixIcon: CupertinoIcons.settings,
            ),
            SizedBox(height: mq.width * 0.04),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TransactionScreen(),
                ),
              ),
              child: const ProfileMenuItems(
                description: 'My Transactions',
                prefixIcon: Icons.computer,
              ),
            ),
            SizedBox(height: mq.width * 0.04),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChallengeScreen(),
                ),
              ),
              child: const ProfileMenuItems(
                description: 'My Challenges',
                prefixIcon: Icons.favorite_border,
              ),
            ),
            SizedBox(height: mq.width * 0.04),
            InkWell(
              onTap: logOut,
              child: const ProfileMenuItems(
                description: 'Log-Out',
                prefixIcon: Icons.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
