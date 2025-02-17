import 'package:fin_track/widgets/transaction_lists.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key, required this.category, required this.monthYear});
  final String category;
  final String monthYear;

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Credit"),
              Tab(text: "Debit"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(
                    child: TransactionLists(
                  category: widget.category,
                  type: 'credit',
                  monthYear: widget.monthYear,
                )),
                Center(
                    child: TransactionLists(
                  category: widget.category,
                  type: 'debit',
                  monthYear: widget.monthYear,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
