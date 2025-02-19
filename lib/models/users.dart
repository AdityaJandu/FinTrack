class Users {
  String uid;
  String name;
  String email;
  String phoneNumber;
  double remainingAmount;
  double totalCredit;
  double totalDebit;
  String password;

  Users({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.remainingAmount = 0.0,
    this.totalCredit = 0.0,
    this.totalDebit = 0.0,
  });

  // Convert UserModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'remainingAmount': remainingAmount,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'password': password,
    };
  }

  // Create UserModel from a Firestore document
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      remainingAmount: (map['remainingAmount'] ?? 0.0).toDouble(),
      totalCredit: (map['totalCredit'] ?? 0.0).toDouble(),
      totalDebit: (map['totalDebit'] ?? 0.0).toDouble(),
      password: map['password'] ?? '',
    );
  }
}
