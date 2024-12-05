import 'package:flutter/material.dart';
import 'package:pam_final_client/components/profile.dart';
import 'package:pam_final_client/components/text.dart';
import 'package:pam_final_client/instances/client.dart';
import 'package:pam_final_client/pages/app/page_currency.dart';
import 'package:pam_final_client/pages/app/page_settings.dart';
import 'package:pam_final_client/pages/page_login.dart';

class AppProfile extends StatefulWidget {
  final void Function(String) changeMode;
  final void Function(String) changeTheme;

  const AppProfile({
    super.key,
    required this.changeMode,
    required this.changeTheme,
  });

  @override
  State<AppProfile> createState() => _AppProfileState();
}

class _AppProfileState extends State<AppProfile> {
  late int userId;
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();

    // Get the current user
    Client().getUser(
      onSuccess: (user) {
        setState(() {
          userId = user.id;
          userName = user.name;
          userEmail = user.email;
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
        title: const Text("Profil"),
      ),
      body: Center(
        child: Column(
          children: [
            CProfileAvatar(
              text: userName,
              radius: 40,
            ),
            const SizedBox(height: 10),
            CTextHeader(text: userName),
            const SizedBox(height: 10),
            Text(
              userEmail,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              title: const Text("Pengaturan"),
              leading: const Icon(Icons.settings),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageSettings(
                      changeMode: widget.changeMode,
                      changeTheme: widget.changeTheme,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Konversi Mata Uang"),
              leading: const Icon(Icons.settings),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageCurrency(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                "Keluar",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              visualDensity: VisualDensity.compact,
              tileColor: Theme.of(context).colorScheme.primaryContainer,
              onTap: () {
                Client().removeToken();

                // Change the mode and theme to the default
                widget.changeMode("light");
                widget.changeTheme("blue");

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageLogin(
                      changeMode: widget.changeMode,
                      changeTheme: widget.changeTheme,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
