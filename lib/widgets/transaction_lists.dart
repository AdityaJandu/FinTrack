import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/components/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionLists extends StatelessWidget {
  TransactionLists(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});

  final String category;
  final String type;
  final String monthYear;
  final String userDetails = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    try {
      Query query = FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails)
          .collection('transactions')
          .orderBy('timeStamp', descending: true)
          .where('monthYear', isEqualTo: monthYear)
          .where('type', isEqualTo: type);

      if (category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      return FutureBuilder<QuerySnapshot>(
        future: query.limit(150).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Transform.scale(
                scale: 1.5,
                child: const CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("No transactions found.");
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, int index) {
              var cardData = data[index];
              return TransactionCard(
                cardData: cardData,
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Exception: $e\nStackTrace: $stackTrace");
      return const Text('An unexpected error occurred.');
    }
  }
}
