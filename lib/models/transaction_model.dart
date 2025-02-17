class TransactionModel {
  String id;
  String title;
  int amount;
  String type;
  int timeStamp;
  int totalCredit;
  int totalDebit;
  int remainingAmount;
  String monthYear;
  String category;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.timeStamp,
    required this.totalCredit,
    required this.totalDebit,
    required this.remainingAmount,
    required this.monthYear,
    required this.category,
  });

  // Convert TransactionModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'timeStamp': timeStamp,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'remainingAmount': remainingAmount,
      'monthYear': monthYear,
      'category': category,
    };
  }

  // Create TransactionModel from a Firestore document
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toInt(),
      type: map['type'] ?? '',
      timeStamp: (map['timeStamp'] ?? 0).toInt(),
      totalCredit: (map['totalCredit'] ?? 0).toInt(),
      totalDebit: (map['totalDebit'] ?? 0).toInt(),
      remainingAmount: (map['remainingAmount'] ?? 0).toInt(),
      monthYear: map['monthYear'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
