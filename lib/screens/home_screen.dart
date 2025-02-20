import 'package:fin_track/main.dart';
import 'package:fin_track/widgets/add_transaction_form.dart';
import 'package:fin_track/widgets/get_user_name.dart';
import 'package:fin_track/widgets/hero_card.dart';
import 'package:fin_track/widgets/transaction_part.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _showDialog() {
    return showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        content: AddTransactionForm(),
      ),
    );
  }

  final String userDetails = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xfffbc2eb),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GetUserName(documentId: userDetails),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: mq.height,
            width: mq.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffbc2eb),
                  Color(0xffa6c1ee),
                ],
                begin: Alignment(0, 0),
                end: Alignment(1, 1),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
