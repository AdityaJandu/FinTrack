import 'package:fin_track/main.dart';
import 'package:fin_track/services/challenge_services.dart';
import 'package:fin_track/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _goalAmountController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final AppValidator _appValidator = AppValidator();
  final ChallengeService _challengeService = ChallengeService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _goalAmountController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Create challenges and join those right away.
  Future<void> _createAndJoinChallenge() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      String? newChallengeId;
      bool creationSuccess = false;
      bool joinSuccess = false;

      try {
        int goalAmount = int.parse(_goalAmountController.text);
        int duration = int.parse(_durationController.text);

        newChallengeId = await _challengeService.createChallenge(
          title: _titleController.text.trim(),
          goalAmount: goalAmount,
          duration: duration,
        );

        creationSuccess = newChallengeId != null;

        if (creationSuccess && mounted) {
          log("Challenge definition created ($newChallengeId). Attempting to join...");
          joinSuccess = await _challengeService.joinChallenge(newChallengeId);
        }

        if (!mounted) return;

        if (creationSuccess && joinSuccess) {
          log("Challenge created and joined successfully.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Challenge created and joined!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (creationSuccess && !joinSuccess) {
          log("Challenge created, but auto-join failed.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Challenge created, but failed to join automatically. You can join it from the list."),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
          Navigator.pop(context, false);
        } else {
          log("Challenge creation failed.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Failed to create challenge definition. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        log("Error during create/join process: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("An error occurred: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      log("Form validation failed.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fix the errors in the form."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Create Challenge",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xfffbc2eb),
      ),
      body: Stack(
        children: [
          Container(
            height: mq.height,
            width: mq.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffbc2eb),
                  Color(0xffa6c1ee),
                ],
                begin: Alignment(0, 0),
                end: Alignment(1, 1),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: mq.height * .02),
                    TextFormField(
                      controller: _titleController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Challenge Title",
                        hintText: "e.g., Save for New Phone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: _appValidator.validateTitle,
                    ),
                    SizedBox(height: mq.height * .02),
                    TextFormField(
                      controller: _goalAmountController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Goal Amount (₹)",
                        hintText: "e.g., 10000",
                        prefixText: "₹ ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: _appValidator.validatePositiveNumber,
                    ),
                    SizedBox(height: mq.height * .02),
                    TextFormField(
                      controller: _durationController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Target Duration (days)",
                        hintText: "e.g., 60",
                        suffixText: " days",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: _appValidator.validatePositiveNumber,
                    ),
                    SizedBox(height: mq.height * .04),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _createAndJoinChallenge,
                      icon: _isLoading
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator.adaptive(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white)),
                            )
                          : const Icon(Icons.add_task_rounded),
                      label: Text(_isLoading ? "Creating..." : "Create & Join"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(mq.width * .7, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * .02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
