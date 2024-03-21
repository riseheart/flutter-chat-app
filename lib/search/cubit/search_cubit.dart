import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSearchCubit extends Cubit<List<Map<String, dynamic>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  UserSearchCubit() : super([]);

  void searchUsers(String username) async {
    try {
      if (username.isEmpty) {
        emit([]);
        return;
      }
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThan: username + 'z')
          .get();

      final List<Map<String, dynamic>> users = querySnapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => {
                'username': doc['username'],
                'email': doc['email'],
                'uid': doc['uid'],
              })
          .toList();
      emit(users);
    } catch (error) {
      print('Error searching users: $error');
      emit([]);
    }
  }
}
