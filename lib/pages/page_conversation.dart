import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:pam_final_client/components/profile.dart';

class PageConversation extends StatefulWidget {
  const PageConversation({super.key});

  @override
  State<PageConversation> createState() => _PageConversationState();
}

class _PageConversationState extends State<PageConversation> {
  final int userId = 1;
  final List<Map<String, dynamic>> conversation = [
    {
      "id": 1,
      "sender_id": 1,
      "receiver_id": 2,
      "content": "Hello, how are you?",
      "timestamp": "2024-11-10T10:30:00Z"
    },
    {
      "id": 2,
      "sender_id": 2,
      "receiver_id": 1,
      "content": "I'm good, thank you!",
      "timestamp": "2024-11-10T10:31:00Z"
    },
    {
      "id": 3,
      "sender_id": 1,
      "receiver_id": 2,
      "content": "What are you doing?",
      "timestamp": "2024-11-10T10:32:00Z"
    },
    {
      "id": 4,
      "sender_id": 2,
      "receiver_id": 1,
      "content": "Just working on a project.",
      "timestamp": "2024-11-10T10:33:00Z"
    },
    {
      "id": 5,
      "sender_id": 1,
      "receiver_id": 2,
      "content": "Sounds interesting!",
      "timestamp": "2024-11-10T10:34:00Z"
    },
    {
      "id": 6,
      "sender_id": 2,
      "receiver_id": 1,
      "content": "Yes, it is. How about you?",
      "timestamp": "2024-11-10T10:35:00Z"
    },
    {
      "id": 7,
      "sender_id": 1,
      "receiver_id": 2,
      "content": "Are you free this weekend?",
      "timestamp": "2024-11-10T10:36:00Z"
    },
    {
      "id": 8,
      "sender_id": 1,
      "receiver_id": 2,
      "content": "We could catch up over coffee.",
      "timestamp": "2024-11-10T10:37:00Z"
    },
    {
      "id": 9,
      "sender_id": 2,
      "receiver_id": 1,
      "content": "Sure, that sounds great!",
      "timestamp": "2024-11-10T10:38:00Z"
    },
    {
      "id": 10,
      "sender_id": 2,
      "receiver_id": 1,
      "content": "Let's meet at our usual place.",
      "timestamp": "2024-11-10T10:39:00Z"
    },
    {
      "id": 11,
      "sender_id": 1,
      "receiver_id": 2,
      "content": "See you there!",
      "timestamp": "2024-11-10T10:40:00Z"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CProfileChat(text: "Alexander Wahyu"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              itemCount: conversation.length,
              itemBuilder: (context, index) {
                final chat = conversation[index];

                // Check if the current chat is the last chat in the list
                // or if the sender is different from the next chat
                final tail = index == conversation.length - 1 ||
                    conversation[index + 1]["sender_id"] != chat["sender_id"];
                return ChatBubble(chat: chat, tail: tail);
              },
            ),
          ),
          MessageBar(
            sendButtonColor: Theme.of(context).colorScheme.primary,
            messageBarColor: Theme.of(context).colorScheme.surface,
            messageBarHintText: "Ketik pesan...",
            onSend: (message) {
              setState(() {
                conversation.add({
                  "id": conversation.length + 1,
                  "sender_id": userId,
                  "receiver_id": 2,
                  "content": message,
                  "timestamp": DateTime.now().toIso8601String(),
                });
              });
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> chat;
  final bool tail;
  final int userId = 1;

  const ChatBubble({
    super.key,
    required this.chat,
    required this.tail,
  });

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
      text: chat["content"],
      isSender: chat["sender_id"] == userId,
      color: chat["sender_id"] == userId
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary,
      textStyle: TextStyle(
        color: chat["sender_id"] == userId
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSecondary,
      ),
      tail: tail,
    );
  }
}
