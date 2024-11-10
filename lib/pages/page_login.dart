import 'package:flutter/material.dart';
import 'package:pam_final_client/components/icon.dart';
import 'package:pam_final_client/components/input.dart';
import 'package:pam_final_client/components/text.dart';

class Pagelogin extends StatefulWidget {
  const Pagelogin({super.key});

  @override
  State<Pagelogin> createState() => _PageloginState();
}

class _PageloginState extends State<Pagelogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masuk"),
      ),
      body: Center(
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
                onPressed: () {},
                child: const Text("Masuk"),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Belum punya akun? Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
