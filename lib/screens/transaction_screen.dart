import 'package:fin_track/services/auth_services.dart';
import 'package:fin_track/widgets/catergory_lists.dart';
import 'package:fin_track/components/my_tab_bar.dart';
import 'package:fin_track/components/time_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final AuthServices authServices = AuthServices();

  String monthYear = ''; // Default value
  String category = 'All'; // Default category

  @override
  void initState() {
    super.initState();
    // Automatically set the current month & year
    setState(() {
      DateTime now = DateTime.now();
      monthYear =
          DateFormat('MMM y').format(now); // Example: "2-2025" for Feb 2025
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Column(
        children: [
          TimeLine(onChanged: (String? value) {
            setState(() {
              monthYear = value ?? monthYear;
            });
          }),
          CatergoryLists(onChanged: (String? value) {
            setState(() {
              category = value ?? category;
            });
          }),
          Expanded(
            child: MyTabBar(category: category, monthYear: monthYear),
          ),
        ],
      ),
    );
  }
}
