import 'package:fin_track/main.dart';
import 'package:fin_track/screens/update_transaction_screen.dart';
import 'package:fin_track/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.cardData,
  });

  final dynamic cardData;

  final AppIcons appIcons = AppIcons();

  void onLongPress(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Edit',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              "Do you really want to update this transaction?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.shade200,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    'Cancel',
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateTransactionScreen(
                      id: cardData['id'],
                      previousType: cardData['type'],
                      previousAmount: cardData['amount'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.shade200,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    'Continue',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(cardData['timeStamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueGrey.shade50,
        ),
        child: InkWell(
          onLongPress: () {
            onLongPress(context);
          },
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: cardData['type'] == 'credit'
                        ? Colors.blue.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                FaIcon(
                  appIcons.getExpenseCategoryIcons(cardData['category']),
                  color: cardData['type'] == 'credit'
                      ? Colors.green.shade400
                      : Colors.deepOrange.shade400,
                ),
              ],
            ),
            title: Row(
              children: [
                Text(cardData['title']),
                const Spacer(),
                Text('₹ ${cardData['amount']}'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Balance',
                    ),
                    const Spacer(),
                    Text('₹ ${cardData['remainingAmount']}'),
                  ],
                ),
                Text(formatedDate)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
