import 'package:fin_track/main.dart';
import 'package:flutter/material.dart';

class ProfileMenuItems extends StatelessWidget {
  const ProfileMenuItems({
    super.key,
    required this.description,
    required this.prefixIcon,
  });

  final String description;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: mq.width,
        height: mq.height * .07,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                prefixIcon,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                description,
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF757575),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
