import 'package:flutter/material.dart';
import 'package:pam_final_client/components/input.dart';
import 'package:pam_final_client/components/popup.dart';
import 'package:pam_final_client/components/profile.dart';
import 'package:pam_final_client/instances/client.dart';
import 'package:pam_final_client/instances/server.dart';

class AppChats extends StatefulWidget {
  const AppChats({super.key});

  @override
  State<AppChats> createState() => _AppChatsState();
}

class _AppChatsState extends State<AppChats> {
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

  List<User> _users = [];

  final TextEditingController _searchController = TextEditingController();
  var _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Server().getUsers(
      onSucess: (users) {
        setState(() {
          _users = users;
        });
      },
      onError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.response?.data["message"] ?? e.message,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !_isSearching,
        title: _isSearching
            ? CTextSearch(controller: _searchController, hintText: "Cari pesan")
            : const Text(
                "HaloTalk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          if (!_isSearching)
            CPopup(
              menuChildren: [
                ListTile(
                  title: const Text("Pengaturan"),
                  leading: const Icon(Icons.settings),
                  visualDensity: VisualDensity.compact,
                  onTap: () {},
                ),
                ListTile(
                  title: const Text("Keluar"),
                  leading: const Icon(Icons.logout),
                  visualDensity: VisualDensity.compact,
                  onTap: () {},
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ChatCard(
                  name: chats[index]["name"],
                  message: chats[index]["message"],
                  timestamp: chats[index]["timestamp"],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var token = await Client().getToken();
          print(token);
        },
        child: const Icon(Icons.add),
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
