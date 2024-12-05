import 'package:flutter/material.dart';
import 'package:pam_final_client/instances/server.dart';
import 'package:pam_final_client/pages/app/app_chats.dart';
import 'package:pam_final_client/pages/app/app_profile.dart';

class App extends StatefulWidget {
  final void Function(String) changeMode;
  final void Function(String) changeTheme;

  const App({
    super.key,
    required this.changeMode,
    required this.changeTheme,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Get user preferences
    Server().getPreferences(
      onSuccess: (preferences) {
        widget.changeMode(preferences.mode);
        widget.changeTheme(preferences.theme);
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
      body: [
        AppChats(
          changeMode: widget.changeMode,
          changeTheme: widget.changeTheme,
        ),
        AppProfile(
          changeMode: widget.changeMode,
          changeTheme: widget.changeTheme,
        ),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Obrolan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
