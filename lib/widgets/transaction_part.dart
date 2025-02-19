import 'package:fin_track/screens/transaction_screen.dart';
import 'package:fin_track/widgets/recent_transaction.dart';
import 'package:flutter/material.dart';

class TransactionPart extends StatefulWidget {
  const TransactionPart({super.key});

  @override
  State<TransactionPart> createState() => _TransactionPartState();
}

class _TransactionPartState extends State<TransactionPart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transctions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransactionScreen(),
                    ),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        RecentTransaction(),
      ],
    );
  }
}
