import 'package:fin_track/widgets/get_user_details.dart';
import 'package:flutter/material.dart';

class ProfileComponent extends StatelessWidget {
  const ProfileComponent(
      {super.key,
      required this.userDetails,
      required this.requiredField,
      required this.description});

  final String requiredField, description, userDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$description: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        GetUserDetails(
          documentId: userDetails,
          size: 18,
          requiredField: requiredField,
        ),
      ],
    );
  }
}
