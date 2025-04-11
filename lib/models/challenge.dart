import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final int goalAmount;
  final int duration;
  final String? reward;
  final Timestamp timeStamp;
  final int savedAmount;
  final String status;
  final Timestamp? startDate;

  const Challenge({
    required this.id,
    required this.title,
    required this.goalAmount,
    required this.duration,
    this.reward,
    required this.timeStamp,
    required this.savedAmount,
    required this.status,
    this.startDate,
  });

  factory Challenge.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> challengeDoc, {
    int savedAmount = 0,
    String status = 'not_joined',
    Timestamp? startDate,
  }) {
    final data = challengeDoc.data() ?? {};

    return Challenge(
      id: challengeDoc.id,
      title: data['title'] as String? ?? 'Untitled Challenge',
      goalAmount: data['goalAmount'] as int? ?? 0,
      duration: data['duration'] as int? ?? 0,
      reward: data['reward'] as String?,
      timeStamp: (data['timeStamp'] is Timestamp
          ? data['timeStamp']
          : Timestamp.now()),
      savedAmount: savedAmount,
      status: status,
      startDate: startDate,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isOngoing => status == 'ongoing';
  bool get isJoined => status != 'not_joined';
  bool get hasStarted => startDate != null;

  @override
  String toString() {
    return 'Challenge(id: $id, title: "$title", goal: $goalAmount, saved: $savedAmount, status: $status)';
  }
}
