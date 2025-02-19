import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  String currentMonth = "";
  List<String> months = [];

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();

    for (int i = -18; i <= 0; i++) {
      months.add(
          DateFormat('MMM y').format(DateTime(now.year, now.month + i, 1)));
    }

    currentMonth = DateFormat('MMM y').format(now);

    setState(() {
      currentMonth;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToSelectedMonth();
    });
  }

  scrollToSelectedMonth() {
    final selextedMonthIndex = months.indexOf(currentMonth);
    if (selextedMonthIndex != -1) {
      final scrollOffset = (selextedMonthIndex * 100.0) - 170.0;
      scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          itemCount: months.length,
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentMonth = months[index];

                  widget.onChanged(months[index]);
                });
                scrollToSelectedMonth();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: currentMonth == months[index]
                      ? Colors.blue.shade400
                      : Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    months[index],
                    style: TextStyle(
                      fontWeight: currentMonth == months[index]
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentMonth == months[index]
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
