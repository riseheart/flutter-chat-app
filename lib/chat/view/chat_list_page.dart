import 'package:chatapp/chat/chat.dart';
import 'package:chatapp/services/services.dart';
import 'package:chatapp/util/util.dart';
import 'package:chatapp/widgets/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat list'),
      ),
      body: ChatList(),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatService _chatService = ChatService();
  final FirestoreService _firestoreService = FirestoreService();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _navigateToChatPage(String username, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverId: id,
          receiverUsername: username,
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _chatService.getLastMessage(currentUserId),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chats = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final members = chat['members'] as List<dynamic>;
                  final otherMemberId = members
                      .firstWhere((memberId) => memberId != currentUserId);
                  String formattedDate =
                      DateTimeFormat.formatDateTime(chat['timestamp']);
                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestoreService.getUserInfo(otherMemberId),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: const Text('Loading...'),
                          subtitle: Text(chat['lastMessage'] ?? ''),
                        );
                      }
                      if (snapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${snapshot.error}'),
                          subtitle: Text(chat['lastMessage'] ?? ''),
                        );
                      }
                      final otherMemberData = snapshot.data?.data() ?? {};
                      final otherMemberUsername =
                          otherMemberData is Map<String, dynamic>
                              ? otherMemberData['username'] ?? ''
                              : '';

                      return ListTile(
                        leading: Avatar(),
                        title: Text(otherMemberUsername),
                        subtitle: Text(chat['lastMessage'] ?? ''),
                        onTap: () {
                          _navigateToChatPage(
                            otherMemberUsername,
                            otherMemberId,
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
