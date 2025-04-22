import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/components/transaction_card.dart';
import 'package:fin_track/models/transaction_model.dart';
import 'package:fin_track/services/transaction_services.dart';
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
  final TransactionService _service = TransactionService();

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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "No ${category.toLowerCase()} and $type transactions found in $monthYear.\nAdd new transactions now.",
                textAlign: TextAlign.center,
              ),
            );
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, int index) {
              var cardData = data[index];
              return Dismissible(
                key: Key(cardData.id),
                direction: DismissDirection.endToStart,
                background: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                ),
                confirmDismiss: (direction) async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Transaction?"),
                      content: Text(
                          "Are you sure you want to delete the '${cardData['title']}' transaction?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete",
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                  return confirm ?? false;
                },
                onDismissed: (direction) {
                  _service.deleteTransaction(
                      transactionId: cardData.id,
                      amount: cardData['amount'],
                      transactionType: cardData['type'],
                      context: context);
                },
                child: TransactionCard(
                  cardData: cardData,
                ),
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
