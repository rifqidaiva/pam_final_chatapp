import 'package:flutter/material.dart';
import 'package:pam_final_client/components/profile.dart';
import 'package:pam_final_client/components/text.dart';

class AppProfile extends StatefulWidget {
  const AppProfile({super.key});

  @override
  State<AppProfile> createState() => _AppProfileState();
}

class _AppProfileState extends State<AppProfile> {
  final userID = 1;
  final userName = "User 1";
  final userEmail = "user@gmail.com";

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
      ),
    );
  }
}
