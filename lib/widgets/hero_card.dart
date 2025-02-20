import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/main.dart';
import 'package:flutter/material.dart';
import 'credit_debit_card.dart';

/*

Hero Card
----------

A simple card to find all the deatils related the balance 
=> total , credited and debited.

*/

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Document doesnot exists');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;

        return CardDetails(
          data: data,
        );
      },
    );
  }
}

class CardDetails extends StatelessWidget {
  const CardDetails({
    super.key,
    required this.data,
  });

  final Map data;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Container(
        width: mq.width,
        height: mq.width / 1.7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xffff8d6c),
                Color(0xffe064f7),
                Color(0xff00b2e7),
              ],
              transform: GradientRotation(pi / 6),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey.shade400,
                offset: const Offset(5, 5),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Total Balance",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              "₹ ${data['remainingAmount']}",
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: CreditDebitCard(data: data),
            ),
          ],
        ),
      ),
    );
  }
}
