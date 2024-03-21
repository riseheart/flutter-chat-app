import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String content, String senderId, String receiverId) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    try {
      await _firestore.collection('messages').add({
        'chatId': chatId,
        'content': content,
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': Timestamp.now(),
      });

      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      if (chatDoc.exists) {
        await _firestore.collection('chats').doc(chatId).update({
          'lastMessage': content,
          'senderId': senderId,
          'timestamp': Timestamp.now(),
        });
      } else {
        await _firestore.collection('chats').doc(chatId).set({
          'members': ids,
          'lastMessage': content,
          'senderId': senderId,
          'timestamp': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
  }
}
