import 'package:fin_track/components/challenge_card.dart';
import 'package:fin_track/models/challenge.dart';
import 'package:fin_track/screens/add_challenge_screen.dart';
import 'package:fin_track/services/challenge_services.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService _challengeService = ChallengeService();

  // When a challenge is completed.
  void _showChallengeCompleteDialog(String challengeId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Challenge Completed"),
          content:
              const Text("Congratulations! You've completed your challenge."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // When you want to add savings to complete the challenge or partially completing challenge.
  void _showAddSavingsDialog(
      Challenge challenge, int remainingAmount, Function(int) onUpdate) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Savings"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter amount (₹)"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                int amount = int.tryParse(amountController.text) ?? 0;
                if (amount > 0 && amount <= remainingAmount) {
                  _challengeService.updateSavings(challenge.id, amount,
                      (updatedAmount) {
                    onUpdate(updatedAmount);

                    if (updatedAmount >= challenge.goalAmount) {
                      _showChallengeCompleteDialog(challenge.id);
                      _challengeService.markChallengeComplete(challenge.id);
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Savings added.")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a valid amount")));
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            "Challenges",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: StreamBuilder<List<Challenge>>(
        stream: _challengeService.getChallengesWithUserProgress(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(
              child: Transform.scale(
                scale: 1.5,
                child: const CircularProgressIndicator.adaptive(),
              ),
            );
          }

          var challenges = snapshot.data!;
          if (challenges.isEmpty) {
            return const Center(child: Text("No Challenges Available"));
          }

          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              var challenge = challenges[index];
              var remainingAmount =
                  challenge.goalAmount - challenge.savedAmount;
              bool isJoined = challenge.savedAmount > 0;

              return ChallengeCard(
                challenge: challenge,
                remainingAmount: remainingAmount,
                isJoined: isJoined,
                onAddSavings: () {
                  _showAddSavingsDialog(challenge, remainingAmount,
                      (updatedAmount) {
                    setState(() {});
                  });
                },
                onJoin: () async {
                  await _challengeService.joinChallenge(challenge.id, context);
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddChallengeScreen()));
        },
        tooltip: "Create Challenge",
        child: const Icon(Icons.add),
      ),
    );
  }
}
