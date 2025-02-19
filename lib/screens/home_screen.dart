import 'package:fin_track/main.dart';
import 'package:fin_track/services/auth_services.dart';
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
  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffad0c4),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetUserName(documentId: userDetails),
              InkWell(
                onTap: _authServices.logOut,
                child: const Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              height: mq.height,
              width: mq.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffad0c4),
                    Color(0xffffd1ff),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                HeroCard(
                  userId: userDetails,
                ),
                const TransactionPart(),
              ],
            ),
          ],
        ),
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
