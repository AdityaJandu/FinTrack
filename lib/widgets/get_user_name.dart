import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*

To get the name of the user and other user details for building profile of the user.

*/

class GetUserName extends StatelessWidget {
  const GetUserName({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            "Hi, ${capitalize(data['name'])}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
