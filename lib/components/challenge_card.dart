import 'package:flutter/material.dart';
import 'package:fin_track/models/challenge.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final int remainingAmount;
  final bool isJoined;
  final VoidCallback onJoin;
  final VoidCallback onAddSavings;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.remainingAmount,
    required this.isJoined,
    required this.onJoin,
    required this.onAddSavings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onAddSavings,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              challenge.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: isJoined
                ? Text('Remaining: ₹$remainingAmount to complete')
                : Text(
                    'Goal: ₹${challenge.goalAmount} in ${challenge.duration} days'),
            trailing: ElevatedButton(
              onPressed: isJoined ? onAddSavings : onJoin,
              child: Text(isJoined ? "Add Savings" : "Join"),
            ),
          ),
        ),
      ),
    );
  }
}
