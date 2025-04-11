import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/models/challenge.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Create challenges:
  Future<String?> createChallenge({
    required String title,
    required int goalAmount,
    required int duration,
    String? reward,
  }) async {
    final userId = _userId;
    if (userId == null) {
      log("Error: User not logged in.");
      return null;
    }
    try {
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('challenges')
          .add({
        'title': title,
        'goalAmount': goalAmount,
        'duration': duration,
        if (reward != null && reward.isNotEmpty) 'reward': reward,
        'timeStamp': FieldValue.serverTimestamp(),
      });
      log("Challenge created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      log("Error creating challenge: $e");
      return null;
    }
  }

  // Get Challenges :
  Stream<List<Challenge>> getChallengesWithUserProgress() {
    final userId = _userId;
    if (userId == null) {
      log("Error: User not logged in for streaming challenges.");
      return Stream.value([]);
    }

    final userChallengesRef =
        _firestore.collection('users').doc(userId).collection('userChallenges');

    final Set<String> loggedMissingDefs = {};

    return userChallengesRef.snapshots().asyncMap((userProgressSnapshot) async {
      List<Challenge> challenges = [];
      loggedMissingDefs.clear();

      if (userProgressSnapshot.docs.isEmpty) {
        return challenges;
      }

      final challengeIds = userProgressSnapshot.docs
          .map((doc) => doc.data()['challengeId'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      Map<String, DocumentSnapshot<Map<String, dynamic>>> challengeDefsMap = {};
      if (challengeIds.isNotEmpty) {
        List<Future<QuerySnapshot<Map<String, dynamic>>>> fetchFutures = [];
        for (int i = 0; i < challengeIds.length; i += 30) {
          int end =
              (i + 30 < challengeIds.length) ? i + 30 : challengeIds.length;
          List<String?> chunk = challengeIds.sublist(i, end);
          fetchFutures.add(_firestore
              .collection('users')
              .doc(userId)
              .collection('challenges')
              .where(FieldPath.documentId, whereIn: chunk)
              .get());
        }

        try {
          final List<QuerySnapshot<Map<String, dynamic>>> results =
              await Future.wait(fetchFutures);
          for (final snapshot in results) {
            for (var doc in snapshot.docs) {
              challengeDefsMap[doc.id] = doc;
            }
          }
        } catch (e) {
          log("Error fetching challenge definitions batch: $e");
        }
      }

      for (var userProgressDoc in userProgressSnapshot.docs) {
        final progressData = userProgressDoc.data();
        final challengeId = progressData['challengeId'] as String?;

        if (challengeId == null) continue;

        final challengeDefDoc = challengeDefsMap[challengeId];

        if (challengeDefDoc == null || !challengeDefDoc.exists) {
          if (loggedMissingDefs.add(challengeId)) {
            log("Warning: Challenge definition not found for joined challenge ID: $challengeId. Skipping.");
          }
          continue;
        }

        final int savedAmount = progressData['savedAmount'] ?? 0;
        final String status = progressData['status'] ?? 'unknown';
        final Timestamp? startDate = progressData['startDate'];

        challenges.add(Challenge.fromFirestore(
          challengeDefDoc,
          savedAmount: savedAmount,
          status: status,
          startDate: startDate,
        ));
      }

      challenges.sort((a, b) {
        int statusCompare =
            _statusSortOrder(a.status).compareTo(_statusSortOrder(b.status));
        if (statusCompare != 0) return statusCompare;
        return (b.startDate ?? Timestamp(0, 0))
            .compareTo(a.startDate ?? Timestamp(0, 0));
      });

      return challenges;
    }).handleError((error, stackTrace) {
      log("Error in getChallengesWithUserProgress stream: $error",
          error: error, stackTrace: stackTrace);
      return <Challenge>[];
    });
  }

  int _statusSortOrder(String status) {
    switch (status) {
      case 'ongoing':
        return 0;
      case 'completed':
        return 1;
      default:
        return 2;
    }
  }

  // Join challenge:
  Future<bool> joinChallenge(String challengeId) async {
    final userId = _userId;
    if (userId == null) {
      log("Error: User not logged in.");
      return false;
    }

    final userChallengeRef =
        _firestore.collection('users').doc(userId).collection('userChallenges');

    try {
      final existingJoinQuery = await userChallengeRef
          .where('challengeId', isEqualTo: challengeId)
          .limit(1)
          .get();

      if (existingJoinQuery.docs.isNotEmpty) {
        log("User already joined challenge: $challengeId");
        return true;
      }

      await userChallengeRef.add({
        'userId': userId,
        'challengeId': challengeId,
        'savedAmount': 0,
        'startDate': FieldValue.serverTimestamp(),
        'status': 'ongoing',
      });
      log("Joined challenge '$challengeId' successfully!");
      return true;
    } catch (e) {
      log("Error joining challenge '$challengeId': $e");
      return false;
    }
  }

  // Updates savings:
  Future<int?> updateSavings(String challengeId, int amountToAdd) async {
    final userId = _userId;
    if (userId == null) {
      log("Error: User not logged in.");
      return null;
    }
    if (amountToAdd <= 0) {
      log("Error: Amount to add must be positive.");
      return null;
    }

    final userChallengesRef =
        _firestore.collection('users').doc(userId).collection('userChallenges');

    try {
      final query = await userChallengesRef
          .where('challengeId', isEqualTo: challengeId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        log("Error: User challenge entry not found for challengeId: $challengeId");
        return null;
      }

      var userChallengeDocRef = query.docs.first.reference;
      var userChallengeData = query.docs.first.data();
      var currentSavedAmount = userChallengeData['savedAmount'] ?? 0;

      if (userChallengeData['status'] == 'completed') {
        log("Attempted to add savings to already completed challenge: $challengeId");
        return currentSavedAmount;
      }

      final challengeDefRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('challenges')
          .doc(challengeId);
      final challengeDefSnapshot = await challengeDefRef.get();

      if (!challengeDefSnapshot.exists) {
        log("Error: Challenge definition not found for challengeId: $challengeId during update.");
        return null;
      }
      var goalAmount = challengeDefSnapshot.data()?['goalAmount'] ?? 0;

      var newSavedAmount = currentSavedAmount + amountToAdd;
      String newStatus = 'ongoing';

      if (goalAmount > 0 && newSavedAmount >= goalAmount) {
        newStatus = 'completed';
        log("Challenge '$challengeId' goal reached or exceeded!");
      }

      await userChallengeDocRef.update({
        'savedAmount': newSavedAmount,
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      log("Updated savings for challenge '$challengeId'. New amount: $newSavedAmount, Status: $newStatus");
      return newSavedAmount;
    } catch (e) {
      log("Error updating savings for challenge '$challengeId': $e");
      return null;
    }
  }

  // To delete challenges:
  Future<bool> deleteChallenge(String challengeId) async {
    final userId = _userId;
    if (userId == null) {
      log("Error: User not logged in.");
      return false;
    }

    final challengeDefRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(challengeId);
    final userChallengesQuery = _firestore
        .collection('users')
        .doc(userId)
        .collection('userChallenges')
        .where('challengeId', isEqualTo: challengeId);

    try {
      WriteBatch batch = _firestore.batch();

      batch.delete(challengeDefRef);
      log("Scheduled deletion for challenge definition: $challengeId");

      QuerySnapshot progressSnapshot = await userChallengesQuery.get();
      if (progressSnapshot.docs.isNotEmpty) {
        for (var doc in progressSnapshot.docs) {
          batch.delete(doc.reference);
          log("Scheduled deletion for user challenge progress: ${doc.id} (for challenge $challengeId)");
        }
      } else {
        log("No user progress record found for challenge $challengeId to delete.");
      }

      await batch.commit();
      log("Successfully deleted challenge and associated progress for: $challengeId");
      return true;
    } catch (e) {
      log("Error deleting challenge $challengeId: $e");
      return false;
    }
  }
}
