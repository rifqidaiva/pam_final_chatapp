import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:pam_final_client/components/profile.dart';
import 'package:pam_final_client/instances/client.dart';
import 'package:pam_final_client/instances/server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PageConversation extends StatefulWidget {
  final int otherUserId;

  const PageConversation({
    super.key,
    required this.otherUserId,
  });

  @override
  State<PageConversation> createState() => _PageConversationState();
}

class _PageConversationState extends State<PageConversation> {
  final List<Message> _conversation = [];
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
  );

  // Default current user ID is 1 (Admin)
  int _currentUserId = 1;
  late User _otherUser;

  @override
  void initState() {
    super.initState();

    // Get the conversation between the current user and the other user
    Server().getConversation(
      otherUserId: widget.otherUserId,
      onSuccess: (messages) {
        setState(() {
          _conversation.addAll(messages);
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

    // Get the other user
    Server().getUserById(
      id: widget.otherUserId,
      onSuccess: (user) {
        setState(() {
          _otherUser = user;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncInitState();
    });
  }

  _asyncInitState() async {
    await _channel.ready;

    String token = await Client().getToken();

    _channel.sink.add("Bearer $token");
    _channel.stream.listen((data) {
      final jsonData = jsonDecode(data);
      final message = Message.fromJson(jsonData);

      setState(() {
        _conversation.add(message);
      });
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
        leadingWidth: 24,
        title: const CProfileChat(text: "Alexander Wahyu"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              itemCount: _conversation.length,
              itemBuilder: (context, index) {
                final chat = _conversation[index];

                // Check if the current chat is the last chat in the list
                // or if the sender is different from the next chat
                final tail = index == _conversation.length - 1 ||
                    _conversation[index + 1].senderId != chat.senderId;
                return ChatBubble(
                    currentUserId: _currentUserId, chat: chat, tail: tail);
              },
            ),
          ),
          MessageBar(
            sendButtonColor: Theme.of(context).colorScheme.primary,
            messageBarColor: Theme.of(context).colorScheme.surface,
            messageBarHintText: "Ketik pesan...",
            onSend: (message) {
              setState(() {
                _channel.sink.add(
                  Message(
                    senderId: _currentUserId,
                    receiverId: _otherUser.id,
                    content: message,
                  ).toJson(),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message chat;
  final bool tail;
  final int currentUserId;

  const ChatBubble({
    super.key,
    required this.chat,
    required this.tail,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
      text: chat.content,
      isSender: chat.senderId == currentUserId,
      color: chat.senderId == currentUserId
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary,
      textStyle: TextStyle(
        color: chat.senderId == currentUserId
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSecondary,
      ),
      tail: tail,
    );
  }
}
