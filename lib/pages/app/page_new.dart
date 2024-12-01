import 'package:flutter/material.dart';
import 'package:pam_final_client/components/profile.dart';
import 'package:pam_final_client/instances/server.dart';
import 'package:pam_final_client/pages/app/page_conversation.dart';

class PageNew extends StatefulWidget {
  const PageNew({super.key});

  @override
  State<PageNew> createState() => _PageNewState();
}

class _PageNewState extends State<PageNew> {
  final List<User> _users = [];

  @override
  void initState() {
    super.initState();

    // Get all users
    Server().getUsers(
      onSuccess: (users) {
        setState(() {
          _users.addAll(users);
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
        title: const Text("Pesan Baru"),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          return UserCard(
            name: user.name,
            email: user.email,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageConversation(
                    otherUserId: user.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final void Function() onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CProfileAvatar(text: name),
      subtitle: Text(email),
      onTap: onTap,
    );
  }
}
