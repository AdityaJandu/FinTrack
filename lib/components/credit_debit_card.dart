import 'package:fin_track/components/circular_icon.dart';
import 'package:flutter/material.dart';

class CreditDebitCard extends StatelessWidget {
  const CreditDebitCard({
    super.key,
    required this.data,
  });

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircularIcon(
          string: 'credit',
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text(
              "Credits",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            Text(
              "${data['totalCredit']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const Spacer(),
        const CircularIcon(
          string: 'debit',
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text(
              "Debits",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${data['totalDebit']}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
