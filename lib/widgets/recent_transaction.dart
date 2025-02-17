import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'transaction_card.dart';

class RecentTransaction extends StatelessWidget {
  RecentTransaction({
    super.key,
  });

  final String userDetails = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails)
          .collection('transactions')
          .orderBy('timeStamp', descending: true)
          .limit(20)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading.");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No transactions found.");
        }

        var data = snapshot.data!.docs;

        return ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
              var cardData = data[index];
              return TransactionCard(
                cardData: cardData,
              );
            });
      },
    );
  }
}
