import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Khởi tạo collection reference
  // CollectionReference get usersCollection => _firestore.collection('users');
  Future<void> saveUserInfoToFirestore({
    required String userId,
    required String username,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'uid': userId,
        'username': username,
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to save user info to Firestore: $e');
    }
  }
}
