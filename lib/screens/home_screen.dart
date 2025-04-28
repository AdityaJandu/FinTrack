import 'package:fin_track/main.dart';
import 'package:fin_track/screens/add_transaction_screen.dart';
import 'package:fin_track/widgets/get_user_details.dart';
import 'package:fin_track/widgets/hero_card.dart';
import 'package:fin_track/widgets/transaction_part.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userDetails = FirebaseAuth.instance.currentUser!.uid;

  void onPressed() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          insetAnimationDuration: const Duration(milliseconds: 400),
          insetAnimationCurve: Curves.bounceInOut,
          title: const Text(
            'Tips',
          ),
          content: const SingleChildScrollView(
            child: Text(
              "Just to update your already added transactions long press and you'll be directed to Update Screen.",
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xfffad0c4),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              const Text(
                'Hi, ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GetUserDetails(
                documentId: userDetails,
                size: 22,
                requiredField: 'name',
              ),
              const Spacer(),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  CupertinoIcons.lightbulb,
                ),
              ),
            ],
          ),
        ),
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeroCard(
                  userId: userDetails,
                ),
                const TransactionPart(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
        },
        tooltip: "Add New Transaction",
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}
