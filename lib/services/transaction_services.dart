import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();

  // Get current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user document from Firestore
  Future<DocumentSnapshot?> getUserDoc(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // Update user balance in Firestore
  Future<void> updateUserBalance({
    required String uid,
    required int remainingAmount,
    required int totalCredit,
    required int totalDebit,
  }) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    await _firestore.collection('users').doc(uid).update({
      "remainingAmount": remainingAmount,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "updatedAt": timeStamp,
    });
  }

  // Add a new transaction
  Future<void> addTransaction({
    required String title,
    required String category,
    required int amount,
    required String transactionType,
  }) async {
    User? user = getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    DocumentSnapshot? userDoc = await getUserDoc(user.uid);
    if (!userDoc!.exists) throw Exception("User document not found");

    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String id = _uuid.v4();
    String monthYear = DateFormat('MMM y').format(DateTime.now());

    // Get user balance details
    int remainingAmount = (userDoc["remainingAmount"] ?? 0).toInt();
    int totalCredit = (userDoc["totalCredit"] ?? 0).toInt();
    int totalDebit = (userDoc["totalDebit"] ?? 0).toInt();

    if (transactionType == 'credit') {
      remainingAmount += amount;
      totalCredit += amount;
    } else {
      remainingAmount -= amount;
      totalDebit += amount;
    }

    // Update user balance
    await updateUserBalance(
      uid: user.uid,
      remainingAmount: remainingAmount,
      totalCredit: totalCredit,
      totalDebit: totalDebit,
    );

    // Create transaction model
    TransactionModel newTransaction = TransactionModel(
      id: id,
      title: title,
      amount: amount,
      type: transactionType,
      timeStamp: timeStamp,
      totalCredit: totalCredit,
      totalDebit: totalDebit,
      remainingAmount: remainingAmount,
      monthYear: monthYear,
      category: category,
    );

    // Save transaction to Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(id)
        .set(newTransaction.toMap());
  }

  // Retrieve all transactions for the current user
  Stream<List<TransactionModel>> getTransactions() {
    User? user = getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Update an existing transaction
  Future<void> updateTransaction({
    required String transactionId,
    required String title,
    required String category,
    required int amount,
    required String transactionType,
    required int previousAmount,
    required String previousType,
  }) async {
    User? user = getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    DocumentSnapshot? userDoc = await getUserDoc(user.uid);
    if (!userDoc!.exists) throw Exception("User document not found");

    int remainingAmount = (userDoc["remainingAmount"] ?? 0).toInt();
    int totalCredit = (userDoc["totalCredit"] ?? 0).toInt();
    int totalDebit = (userDoc["totalDebit"] ?? 0).toInt();

    // Reverse previous transaction's impact
    if (previousType == 'credit') {
      remainingAmount -= previousAmount;
      totalCredit -= previousAmount;
    } else {
      remainingAmount += previousAmount;
      totalDebit -= previousAmount;
    }

    // Apply new transaction's impact
    if (transactionType == 'credit') {
      remainingAmount += amount;
      totalCredit += amount;
    } else {
      remainingAmount -= amount;
      totalDebit += amount;
    }

    // Update user balance
    await updateUserBalance(
      uid: user.uid,
      remainingAmount: remainingAmount,
      totalCredit: totalCredit,
      totalDebit: totalDebit,
    );

    // Update transaction in Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(transactionId)
        .update({
      "title": title,
      "amount": amount,
      "category": category,
      "type": transactionType,
      "remainingAmount": remainingAmount,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "updatedAt": DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Delete a transaction
  Future<void> deleteTransaction({
    required String transactionId,
    required int amount,
    required String transactionType,
  }) async {
    User? user = getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    DocumentSnapshot? userDoc = await getUserDoc(user.uid);
    if (!userDoc!.exists) throw Exception("User document not found");

    int remainingAmount = (userDoc["remainingAmount"] ?? 0).toInt();
    int totalCredit = (userDoc["totalCredit"] ?? 0).toInt();
    int totalDebit = (userDoc["totalDebit"] ?? 0).toInt();

    // Reverse the deleted transaction's impact
    if (transactionType == 'credit') {
      remainingAmount -= amount;
      totalCredit -= amount;
    } else {
      remainingAmount += amount;
      totalDebit -= amount;
    }

    // Update user balance
    await updateUserBalance(
      uid: user.uid,
      remainingAmount: remainingAmount,
      totalCredit: totalCredit,
      totalDebit: totalDebit,
    );

    // Delete transaction from Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }
}
