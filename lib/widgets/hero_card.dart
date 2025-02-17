import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/main.dart';
import 'package:fin_track/widgets/cards.dart';
import 'package:flutter/material.dart';

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
    return SizedBox(
      width: mq.width,
      child: Column(
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "₹ ${data['remainingAmount']}",
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: mq.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Cards(
                    color: Colors.green,
                    about: 'Credit',
                    amount: "${data['totalCredit']}",
                  ),
                  const SizedBox(width: 20),
                  Cards(
                    color: Colors.red,
                    about: 'Debit',
                    amount: "${data['totalDebit']}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
