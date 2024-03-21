import 'package:chatapp/services/services.dart';
import 'package:chatapp/util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.receiverId,
    required this.receiverUsername,
    super.key,
  });
  final String receiverId;
  final String receiverUsername;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  // DateTime? previousMessageTime;

  void _sendMessage() {
    final String content = _messageController.text.trim();
    if (content.isNotEmpty) {
      _chatService.sendMessage(content, currentUserId, widget.receiverId);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _chatService.getMessages(currentUserId, widget.receiverId),
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
                final messages = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message['senderId'] == currentUserId;
                    // if (index == 0) {}

                    // final messageDateTime =
                    //     (message['timestamp'] as Timestamp).toDate();
                    String? formattedDate =
                        DateTimeFormat.formatDateTime(message['timestamp']);

                    // previousMessageTime = messageDateTime;
                    return Column(
                      children: [
                        // if (formattedDate != null)
                        ListTile(
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? Colors.deepPurple
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    message['content'],
                                    style: TextStyle(
                                      color: isCurrentUser
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: Colors.deepPurple,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
