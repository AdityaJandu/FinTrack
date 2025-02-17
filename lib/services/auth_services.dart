import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // For Registering using email and password
  registerUser(data, context) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sign-up failed try again!'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  createUser(String email, String password, context) async {
    try {
      return auth.createUserWithEmailAndPassword(
          email: email, password: password);
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

  logOut() {
    FirebaseAuth.instance.signOut();
  }
}
