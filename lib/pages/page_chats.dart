import 'package:flutter/material.dart';
import 'package:pam_final_client/components/profile.dart';

class PageChats extends StatefulWidget {
  const PageChats({super.key});

  @override
  State<PageChats> createState() => _PageChatsState();
}

class _PageChatsState extends State<PageChats> {
  final List<Map<String, dynamic>> chats = [
    {"name": "User 1", "message": "Message 1", "timestamp": "12:30"},
    {"name": "User 2", "message": "Message 2", "timestamp": "12:30"},
    {"name": "User 3", "message": "Message 3", "timestamp": "12:30"},
    {"name": "User 2", "message": "Message 2", "timestamp": "12:30"},
    {"name": "User 2", "message": "Message 2", "timestamp": "12:30"},
    {"name": "User 3", "message": "Message 3", "timestamp": "12:30"},
    {"name": "User 3", "message": "Message 3", "timestamp": "12:30"},
    {"name": "User 2", "message": "Message 2", "timestamp": "12:30"},
    {"name": "User 3", "message": "Message 3", "timestamp": "12:30"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesan"),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ChatCard(
            name: chats[index]["name"],
            message: chats[index]["message"],
            timestamp: chats[index]["timestamp"],
          );
        },
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  final String name;
  final String message;
  final String timestamp;

  const ChatCard({
    super.key,
    required this.name,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing: Text(timestamp),
      leading: CProfileAvatar(text: name),
    );
  }
}
