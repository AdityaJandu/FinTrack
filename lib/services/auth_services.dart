import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Create a new user:
  createUser(String email, String password, context) async {
    try {
      return auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      showDialog(
        builder: (_) => AlertDialog(
          title: const Text('Sign-up failed try again!'),
          content: Text(e.toString()),
        ),
        context: context,
      );
    }
  }

  // For Loging in using email and password
  logInUser(data, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login failed try again!'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  // Update details of a user:
  Future<void> updateUserDetails({
    required String name,
    required String phoneNumber,
    required String email,
    required String uid,
    context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      });
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Updated Successfullly.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login failed try again!'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  logOut() {
    FirebaseAuth.instance.signOut();
  }
}
