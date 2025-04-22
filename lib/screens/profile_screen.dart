import 'package:fin_track/components/profile_component.dart';
import 'package:fin_track/main.dart';
import 'package:fin_track/widgets/get_user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final String userDetails = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xfffad0c4),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffad0c4),
                  Color(0xffffd1ff),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: mq.width * 0.12),

                // Simple Picture from internet:
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://i.pinimg.com/736x/50/a1/4c/50a14c55cb0563883cf971f206e84fdf.jpg",
                  ),
                  radius: 75,
                ),
                SizedBox(height: mq.width * 0.05),

                // User name:
                GetUserName(
                  documentId: userDetails,
                  size: 20,
                  requiredField: 'name',
                ),
                SizedBox(height: mq.width * 0.02),

                // User email address:
                ProfileComponent(
                  userDetails: userDetails,
                  requiredField: 'email',
                  description: 'e-Mail',
                ),
                SizedBox(height: mq.width * 0.01),

                // User phone number:
                ProfileComponent(
                  userDetails: userDetails,
                  requiredField: 'phoneNumber',
                  description: 'Phone Number',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
