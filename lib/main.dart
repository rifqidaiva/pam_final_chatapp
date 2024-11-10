import 'package:flutter/material.dart';
import 'package:pam_final_client/pages/page_chats.dart';
import 'package:pam_final_client/pages/page_conversation.dart';
import 'package:pam_final_client/pages/page_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tugas Akhir PAM",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      home: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: const [
            Option(title: "Login", page: Pagelogin()),
            Option(title: "Conversation", page: PageConversation()),
            Option(title: "Chats", page: PageChats()),
          ],
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String title;
  final Widget page;

  const Option({super.key, required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
    );
  }
}
