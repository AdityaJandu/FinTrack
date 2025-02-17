import 'package:cloud_firestore/cloud_firestore.dart';

/// Challenge Model
class Challenge {
  final String id;
  final String title;
  final int goalAmount;
  final int duration;
  int savedAmount;

  Challenge({
    required this.id,
    required this.title,
    required this.goalAmount,
    required this.duration,
    this.savedAmount = 0,
  });

  // Fetch challenge from Firestore
  factory Challenge.fromFirestore(DocumentSnapshot doc, {int savedAmount = 0}) {
    var data = doc.data() as Map<String, dynamic>;
    return Challenge(
      id: doc.id,
      title: data['title'],
      goalAmount: data['goalAmount'],
      duration: data['duration'],
      savedAmount: savedAmount,
    );
  }
}
