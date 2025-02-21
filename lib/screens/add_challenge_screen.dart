import 'package:fin_track/main.dart';
import 'package:fin_track/services/challenge_services.dart';
import 'package:fin_track/utils/app_validator.dart';
import 'package:flutter/material.dart';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController goalAmountController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  final AppValidator appValidator = AppValidator();

  final _formKey = GlobalKey<FormState>();

  final ChallengeService _challengeService = ChallengeService();

  ///  Function to show a dialog to create a user challenge
  createChallenge() {
    if (_formKey.currentState!.validate()) {
      int goalAmount = int.tryParse(goalAmountController.text) ?? 0;
      int duration = int.tryParse(durationController.text) ?? 0;

      _challengeService.createChallenge(
        title: titleController.text,
        goalAmount: goalAmount,
        duration: duration,
        reward: "Gold Badge",
      );

      Navigator.pop(context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Add Challenge",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: mq.height * .04,
                ),
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: const Text(
                      "Challenge Title",
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: appValidator.validateTitle,
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                TextFormField(
                  controller: goalAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text(
                      "Challenge Amount",
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: appValidator.validateTitle,
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                TextFormField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text(
                      "Duration",
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: appValidator.validateTitle,
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                InkWell(
                  onTap: createChallenge,
                  child: Container(
                    width: mq.width * .7,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 173, 173, 173),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.save_outlined,
                            color: Colors.black,
                          ),
                          Text(
                            "Add Transaction",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
