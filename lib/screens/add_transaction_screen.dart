import 'package:fin_track/main.dart';
import 'package:fin_track/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../services/transaction_services.dart';
import '../widgets/catergory_dropdown.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  var type = 'credit';
  var catergory = "others";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController ammountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final AppValidator appValidator = AppValidator();
  var uid = const Uuid();

  Future<void> _submitForm(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await TransactionService().addTransaction(
          title: titleController.text.trim(),
          category: catergory,
          amount: int.tryParse(ammountController.text) ?? 0,
          transactionType: type,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xfffbc2eb),
        title: const Text(
          "Add Transaction",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: mq.height,
            width: mq.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 251, 202, 237),
                  Color.fromARGB(255, 180, 205, 248),
                ],
                begin: Alignment(0, 0),
                end: Alignment(1, 1),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: mq.height * .04,
                    ),
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: const Text(
                          "Transaction Title",
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
                      controller: ammountController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: const Text(
                          "Transaction Amount",
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
                    CategoryDropdown(
                      catType: catergory,
                      onChanged: (value) {
                        if (value != null) {
                          setState(
                            () {
                              catergory = value;
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.pink.shade100,
                        ),
                        value: 'credit',
                        items: const [
                          DropdownMenuItem(
                            value: 'credit',
                            child: Text('Credit'),
                          ),
                          DropdownMenuItem(
                            value: 'debit',
                            child: Text('Debit'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              type = value;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    InkWell(
                      onTap: () => _submitForm(context),
                      child: Container(
                        width: mq.width * .7,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 173, 173, 173),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
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
        ],
      ),
    );
  }
}
