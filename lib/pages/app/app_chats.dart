import 'package:flutter/material.dart';
import 'package:pam_final_client/components/input.dart';
import 'package:pam_final_client/components/popup.dart';
import 'package:pam_final_client/components/profile.dart';
import 'package:pam_final_client/instances/client.dart';
import 'package:pam_final_client/instances/server.dart';
import 'package:pam_final_client/pages/app/page_conversation.dart';
import 'package:pam_final_client/pages/app/page_new.dart';
import 'package:pam_final_client/pages/page_login.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppChats extends StatefulWidget {
  const AppChats({super.key});

  @override
  State<AppChats> createState() => _AppChatsState();
}

class _AppChatsState extends State<AppChats> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _chats = [];
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
  );

  // Default current user ID is 1 (Admin in database)
  int _currentUserId = 1;
  var _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _getData() {
    // Get the latest messages from each user
    final Map<int, Map<String, dynamic>> latestMessages = {};

    Server().getAllMessages(
      onSuccess: (messages) {
        for (var message in messages) {
          final otherUserId = message.senderId == _currentUserId
              ? message.receiverId
              : message.senderId;

          if (!latestMessages.containsKey(otherUserId) ||
              message.id! > latestMessages[otherUserId]!["id"]) {
            latestMessages[otherUserId] = {
              "id": message.id,
              "user_id": otherUserId,
              "message": message.content,
              "timestamp": message.timestamp,
            };
          }
        }

        latestMessages.forEach((otherUserId, messageData) {
          Server().getUserById(
            id: otherUserId,
            onSuccess: (user) {
              setState(() {
                _chats.add({
                  "user_id": user.id,
                  "name": user.name,
                  "message": messageData["message"],
                  "timestamp": messageData["timestamp"],
                });
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
  void initState() {
    super.initState();

    // Get the current user
    Client().getUser(
      onSuccess: (user) {
        setState(() {
          _currentUserId = user.id;
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

    _getData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncInitState();
    });
  }

  _asyncInitState() async {
    await _channel.ready;

    String token = await Client().getToken();

    _channel.sink.add("Bearer $token");
    _channel.stream.listen((data) {
      _chats.clear();
      _getData();
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
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
                  title: const Text("Keluar"),
                  leading: const Icon(Icons.logout),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    Client().removeToken();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageLogin(),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                return ChatCard(
                  name: _chats[index]["name"],
                  message: _chats[index]["message"],
                  timestamp: _chats[index]["timestamp"],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageConversation(
                          otherUserId: _chats[index]["user_id"],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PageNew(),
            ),
          );
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
  final void Function() onTap;

  const ChatCard({
    super.key,
    required this.name,
    required this.message,
    required this.timestamp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        Client().convertUtcToWib(timestamp),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      leading: CProfileAvatar(text: name),
      onTap: onTap,
    );
  }
}
