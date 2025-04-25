import 'package:fin_track/main.dart';
import 'package:fin_track/services/transaction_services.dart';
import 'package:fin_track/utils/app_validator.dart';
import 'package:fin_track/widgets/catergory_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UpdateTransactionScreen extends StatefulWidget {
  const UpdateTransactionScreen(
      {super.key,
      required this.id,
      required this.previousType,
      required this.previousAmount});
  final String id, previousType;
  final int previousAmount;

  @override
  State<UpdateTransactionScreen> createState() =>
      _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  var type = 'credit';
  var catergory = "others";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController ammountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final AppValidator appValidator = AppValidator();
  var uid = const Uuid();

  @override
  void dispose() {
    titleController.dispose();
    ammountController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transaction Updating..."),
        ),
      );

      try {
        await TransactionService().updateTransaction(
          transactionId: widget.id,
          title: titleController.text.trim(),
          category: type,
          amount: int.tryParse(ammountController.text) ?? 0,
          transactionType: type,
          previousAmount: widget.previousAmount,
          previousType: widget.previousType,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Transaction Updated Successfully."),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
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
          "Update Transaction",
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
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitForm,
                      icon: isLoading
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
                      label: Text(
                          isLoading ? "Updating..." : "Update Transaction"),
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
