import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    required this.string,
  });
  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        color: Color.fromARGB(125, 255, 255, 255),
        shape: BoxShape.circle,
      ),
      child: Icon(
        string == 'credit'
            ? CupertinoIcons.arrow_up
            : CupertinoIcons.arrow_down,
        size: 16,
        color: string == 'credit' ? Colors.green : Colors.red,
      ),
    );
  }
}
