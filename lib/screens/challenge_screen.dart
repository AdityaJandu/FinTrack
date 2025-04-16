import 'package:fin_track/components/challenge_card.dart';
import 'package:fin_track/main.dart';
import 'package:fin_track/models/challenge.dart';
import 'package:fin_track/screens/add_challenge_screen.dart';
import 'package:fin_track/services/challenge_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService _challengeService = ChallengeService();

  // When the challenge is completed
  void _showChallengeCompleteDialog(String challengeTitle) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("🎉 Challenge Completed! 🎉",
              textAlign: TextAlign.center),
          content: Text(
              "Congratulations! You've completed the '$challengeTitle' challenge.",
              textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Awesome!")),
          ],
        );
      },
    );
  }

  // Show add savings dialog
  void _showAddSavingsDialog(Challenge challenge, int currentRemainingAmount) {
    if (challenge.isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("This challenge is already completed!")));
      return;
    }
    if (!mounted) return;

    TextEditingController amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Add Savings to '${challenge.title}'",
              style: const TextStyle(fontSize: 18)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount (₹)",
                labelText: "Amount",
                prefixText: "₹ ",
                helperText: "Remaining: ₹$currentRemainingAmount",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                int? amount = int.tryParse(value);
                if (amount == null) return 'Please enter a valid number';
                if (amount <= 0) return 'Amount must be positive';
                if (currentRemainingAmount > 0 &&
                    amount > currentRemainingAmount) {
                  return 'Amount exceeds remaining ₹$currentRemainingAmount';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  int amount = int.parse(amountController.text);
                  Navigator.pop(dialogContext);

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Adding ₹$amount savings..."),
                      duration: const Duration(milliseconds: 1200)));

                  int? newTotalSavedAmount = await _challengeService
                      .updateSavings(challenge.id, amount);

                  if (!mounted) return;

                  if (newTotalSavedAmount != null) {
                    log("Savings updated. New total: $newTotalSavedAmount");
                    if (newTotalSavedAmount >= challenge.goalAmount) {
                      if (!challenge.isCompleted) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          _showChallengeCompleteDialog(challenge.title);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Savings added (goal met)!"),
                                duration: Duration(seconds: 2)));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Savings added!"),
                          duration: Duration(seconds: 2)));
                    }
                  } else {
                    log("Failed to update savings for challenge ${challenge.id}.");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Error adding savings. Please try again."),
                        backgroundColor: Colors.red));
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Total savings card at top:
  Widget _buildTotalSavingsCard(int totalSavings) {
    String formattedSavings = "₹$totalSavings";
    double pi = 3.14;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Container(
        width: mq.width,
        height: mq.width / 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: const [
              Color(0xffff8d6c),
              Color(0xffe064f7),
              Color(0xff00b2e7),
            ],
            transform: GradientRotation(pi / 6),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.shade400,
              offset: const Offset(5, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Total Savings",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              formattedSavings,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete a challenge:
  Future<void> _deleteChallenge(Challenge challenge) async {
    if (!mounted) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Deleting '${challenge.title}'..."),
        duration: const Duration(seconds: 2),
      ),
    );
    bool success = await _challengeService.deleteChallenge(challenge.id);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Challenge deleted successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete challenge."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Challenges",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<Challenge>>(
        stream: _challengeService.getChallengesWithUserProgress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            log("StreamBuilder Error: ${snapshot.error}",
                error: snapshot.error, stackTrace: snapshot.stackTrace);
            return Center(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Error loading challenges: ${snapshot.error}",
                        textAlign: TextAlign.center)));
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            int totalSavings =
                snapshot.data?.fold<int>(0, (sum, c) => sum + c.savedAmount) ??
                    0;
            return Column(
              children: [
                _buildTotalSavingsCard(totalSavings),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                          "No active challenges found.\nTap '+' to create one!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ),
                  ),
                )
              ],
            );
          }

          var challenges = snapshot.data!;
          int totalSavings = challenges.fold<int>(
              0, (sum, challenge) => sum + challenge.savedAmount);

          return Column(
            children: [
              _buildTotalSavingsCard(totalSavings),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = challenges[index];
                    final remainingAmount =
                        (challenge.goalAmount - challenge.savedAmount)
                            .clamp(0, challenge.goalAmount);

                    return Dismissible(
                      key: Key(challenge.id),
                      direction: DismissDirection.endToStart,
                      background: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.white),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Challenge?"),
                            content: Text(
                                "Are you sure you want to delete the '${challenge.title}' challenge?"),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
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
                        _deleteChallenge(challenge);
                      },
                      child: ChallengeCard(
                        challenge: challenge,
                        remainingAmount: remainingAmount,
                        onAddSavings: challenge.isCompleted
                            ? null
                            : () {
                                _showAddSavingsDialog(
                                    challenge, remainingAmount);
                              },
                        onJoin: challenge.isJoined || challenge.isCompleted
                            ? null
                            : () async {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Joining '${challenge.title}'...")));
                                bool success = await _challengeService
                                    .joinChallenge(challenge.id);
                                if (!mounted) return;
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Joined '${challenge.title}'!")));
                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Error joining."),
                                          backgroundColor: Colors.red));
                                }
                              },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddChallengeScreen()));
        },
        tooltip: "Create New Challenge",
        icon: const Icon(Icons.add),
        label: const Text("Create"),
      ),
    );
  }
}
