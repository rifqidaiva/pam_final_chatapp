import 'package:flutter/material.dart';

class PageChats extends StatelessWidget {
  const PageChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text("User 1"),
            subtitle: Text("Message 1"),
          ),
          ListTile(
            title: Text("User 2"),
            subtitle: Text("Message 2"),
          ),
          ListTile(
            title: Text("User 3"),
            subtitle: Text("Message 3"),
          ),
        ],
      ),
    );
  }
}
