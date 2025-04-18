import 'package:fin_track/main.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.controller,
      required this.validator,
      required this.description,
      required this.obscureText});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String description;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * .05,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          label: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(description),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
