// ignore_for_file: use_build_context_synchronously

import 'package:fin_track/utils/app_validator.dart';
import 'package:fin_track/widgets/catergory_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../services/transaction_services.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = 'credit';
  var catergory = "others";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final AppValidator appValidator = AppValidator();

  TextEditingController ammountController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  var uid = const Uuid();

  Future<void> _submitForm() async {
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
    return SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: appValidator.validateTitle,
            ),
            TextFormField(
              controller: ammountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              validator: appValidator.validateTitle,
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
            DropdownButtonFormField(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Submit Now."),
            ),
          ],
        ),
      ),
    );
  }
}
