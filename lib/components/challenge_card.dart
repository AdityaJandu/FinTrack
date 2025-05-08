import 'package:flutter/material.dart';
import 'package:fin_track/models/challenge.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final int remainingAmount;
  final VoidCallback? onJoin;
  final VoidCallback? onAddSavings;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.remainingAmount,
    this.onJoin,
    this.onAddSavings,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = challenge.isCompleted;
    final bool isJoined = challenge.isJoined;

    double progress = 0.0;
    if (challenge.goalAmount > 0) {
      progress = (challenge.savedAmount.clamp(0, challenge.goalAmount) /
              challenge.goalAmount)
          .clamp(0.0, 1.0);
    }

    String buttonText;
    VoidCallback? buttonAction;
    Color? buttonBackgroundColor;
    Color? buttonForegroundColor;

    if (isCompleted) {
      buttonText = "Completed";
      buttonAction = null;
      buttonBackgroundColor = Colors.grey.shade300;
      buttonForegroundColor = Colors.grey.shade700;
    } else if (isJoined) {
      buttonText = "Add Savings";
      buttonAction = onAddSavings;
      buttonBackgroundColor = Theme.of(context).colorScheme.secondary;
      buttonForegroundColor = Theme.of(context).colorScheme.onSecondary;
    } else {
      buttonText = "Join";
      buttonAction = onJoin;
      buttonBackgroundColor = Theme.of(context).colorScheme.primary;
      buttonForegroundColor = Theme.of(context).colorScheme.onPrimary;
    }

    String subtitleText;

    // If it's completed
    if (isCompleted) {
      subtitleText = 'Goal Achieved! (₹${challenge.savedAmount} saved)';
    } else if (isJoined) {
      subtitleText =
          'Saved: ₹${challenge.savedAmount} / ₹${challenge.goalAmount}';
    } else {
      subtitleText =
          'Goal: ₹${challenge.goalAmount} in ${challenge.duration} days';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isCompleted ? Colors.green.shade50 : Colors.blueGrey.shade50,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          leading: Icon(
            isCompleted
                ? Icons.check_circle
                : (isJoined ? Icons.savings_rounded : Icons.flag_outlined),
            color: isCompleted
                ? Colors.green.shade700
                : (isJoined
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade600),
            size: 32,
          ),
          title: Text(
            challenge.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: Colors.grey,
              color: isCompleted ? Colors.grey.shade700 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  subtitleText,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
              if (isJoined)
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? Colors.green : Theme.of(context).primaryColor,
                  ),
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(3.5),
                ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: buttonAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackgroundColor,
              foregroundColor: buttonForegroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: buttonAction != null ? 2 : 0,
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
