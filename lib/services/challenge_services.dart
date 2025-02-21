import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/models/challenge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChallengeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload a new challenge to Firestore
  Future<void> createChallenge({
    required String title,
    required int goalAmount,
    required int duration,
    required String reward,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('challenges')
          .add({
        'title': title,
        'goalAmount': goalAmount,
        'duration': duration,
        'reward': reward,
      });
      log("Challenge created successfully!");
    } catch (e) {
      log("Error creating challenge: $e");
    }
  }

  /// Get challenges + user progress
  Stream<List<Challenge>> getChallengesWithUserProgress() {
    String userId = _auth.currentUser!.uid;

    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('challenges')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Challenge> challenges = [];

      for (var doc in snapshot.docs) {
        doc.data();

        // Fetch user's savedAmount from 'userChallenges'
        var userChallengeQuery = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('userChallenges')
            .where('userId', isEqualTo: userId)
            .where('challengeId', isEqualTo: doc.id)
            .get();

        int savedAmount = 0;
        if (userChallengeQuery.docs.isNotEmpty) {
          savedAmount = userChallengeQuery.docs.first['savedAmount'];
        }

        challenges.add(Challenge.fromFirestore(doc, savedAmount: savedAmount));
      }

      return challenges;
    });
  }

  /// Join a challenge
  Future<void> joinChallenge(String challengeId, context) async {
    String userId = _auth.currentUser!.uid;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('userChallenges')
          .add({
        'userId': userId,
        'challengeId': challengeId,
        'savedAmount': 0,
        'startDate': Timestamp.now(),
        'status': 'ongoing',
      });
      log("Joined challenge successfully!");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Joined Successfully"),
          content: const Text("Press on tile to Start Saving Now."),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      log("Error joining challenge: $e");
    }
  }

  /// Update user savings progress and remove challenge if completed
  Future<void> updateSavings(
      String challengeId, int amount, Function onUpdate) async {
    String userId = _auth.currentUser!.uid;

    try {
      var query = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('userChallenges')
          .where('userId', isEqualTo: userId)
          .where('challengeId', isEqualTo: challengeId)
          .get();

      if (query.docs.isNotEmpty) {
        var userChallengeDoc = query.docs.first;
        var currentSavedAmount = userChallengeDoc['savedAmount'];

        // Fetch goalAmount from `challenges` collection
        var challengeSnapshot = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('challenges')
            .doc(challengeId)
            .get();
        if (!challengeSnapshot.exists) return;
        var goalAmount = challengeSnapshot['goalAmount'];

        var newAmount = currentSavedAmount + amount;
        var newStatus = newAmount >= goalAmount ? 'completed' : 'ongoing';

        // Update Firestore
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('userChallenges')
            .doc(userChallengeDoc.id)
            .update({
          'savedAmount': newAmount,
          'status': newStatus,
        });

        // If challenge is completed, remove it from Firestore
        if (newAmount >= goalAmount) {
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('challenges')
              .doc(challengeId)
              .delete();
          log("Challenge completed and removed from Firestore.");
        }

        // Immediately update the UI
        onUpdate(newAmount);

        log("Updated savings successfully!");
      } else {
        log("Error: User challenge entry not found!");
      }
    } catch (e) {
      log("Error updating savings: $e");
    }
  }

  /// Create a user-generated challenge
  Future<void> createUserChallenge({
    required String title,
    required int goalAmount,
    required int duration,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('challenges')
          .add({
        'title': title,
        'goalAmount': goalAmount,
        'duration': duration,
        // No reward is required for user-created challenges
      });
      log("User challenge created successfully!");
    } catch (e) {
      log("Error creating user challenge: $e");
    }
  }

  /// Update user challenge status when complete
  Future<void> markChallengeComplete(String challengeId) async {
    String userId = _auth.currentUser!.uid;

    try {
      var query = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('userChallenges')
          .where('userId', isEqualTo: userId)
          .where('challengeId', isEqualTo: challengeId)
          .get();

      if (query.docs.isNotEmpty) {
        var userChallengeDoc = query.docs.first;
        var currentSavedAmount = userChallengeDoc['savedAmount'];

        // Fetch goalAmount from `challenges` collection
        var challengeSnapshot = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('challenges')
            .doc(challengeId)
            .get();

        if (!challengeSnapshot.exists) return;
        var goalAmount = challengeSnapshot['goalAmount'];

        // Check if the challenge is complete
        if (currentSavedAmount >= goalAmount) {
          // Update the challenge status to 'completed'
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('userChallenges')
              .doc(userChallengeDoc.id)
              .update({
            'status': 'completed',
          });

          // Optionally, remove the challenge or perform other actions
          log("Challenge completed!");
        }
      }
    } catch (e) {
      log("Error marking challenge as complete: $e");
    }
  }
}
