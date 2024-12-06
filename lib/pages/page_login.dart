import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pam_final_client/components/icon.dart';
import 'package:pam_final_client/components/input.dart';
import 'package:pam_final_client/components/text.dart';
import 'package:pam_final_client/instances/client.dart';
import 'package:pam_final_client/pages/app/app.dart';
import 'package:pam_final_client/pages/page_register.dart';
import 'package:pam_final_client/instances/server.dart';

class PageLogin extends StatefulWidget {
  final void Function(String) changeMode;
  final void Function(String) changeTheme;

  const PageLogin({
    super.key,
    required this.changeMode,
    required this.changeTheme,
  });

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masuk"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CIconHeader(icon: Icons.login_rounded),
              const CTextHeader(text: "Masuk HaloTalk"),
              const SizedBox(height: 16),
              const Text(
                "Silahkan masuk dengan menggunakan email dan password Anda untuk melanjutkan ke aplikasi.",
              ),
              const SizedBox(height: 16),
              CTextField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email,
                obscureText: false,
              ),
              CTextField(
                controller: _passwordController,
                labelText: "Password",
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              FilledButton(
                child: const Text("Masuk"),
                onPressed: () {
                  Server().login(
                    email: _emailController.text,
                    password: _passwordController.text,
                    onSuccess: (token) {
                      Client().setToken(token);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => App(
                            changeMode: widget.changeMode,
                            changeTheme: widget.changeTheme,
                          ),
                        ),
                      );
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
                },
              ),
              TextButton(
                child: const Text("Belum punya akun? Daftar"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageRegister(
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
      ),
    );
  }
}
