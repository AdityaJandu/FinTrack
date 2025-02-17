import 'package:flutter/cupertino.dart';

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.color,
    required this.about,
    required this.amount,
  });

  final Color color;

  final String about;

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      about,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      "₹ $amount",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Icon(
                about == 'Credit'
                    ? CupertinoIcons.arrow_up
                    : CupertinoIcons.arrow_down,
                color: color,
              )
            ],
          )
        ],
      ),
    );
  }
}
