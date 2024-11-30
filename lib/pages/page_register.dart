import 'package:flutter/material.dart';
import 'package:pam_final_client/components/icon.dart';
import 'package:pam_final_client/components/input.dart';
import 'package:pam_final_client/components/text.dart';
import 'package:pam_final_client/pages/page_login.dart';
import 'package:pam_final_client/instances/server.dart';

class PageRegister extends StatefulWidget {
  const PageRegister({super.key});

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isPasswordMatch() {
    return _passwordController.text == _passwordConfirmController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CIconHeader(icon: Icons.app_registration_rounded),
              const CTextHeader(text: "Daftar HaloTalk"),
              const SizedBox(height: 16),
              const Text(
                "Silahkan daftar dengan menggunakan email dan password Anda untuk melanjutkan ke aplikasi.",
              ),
              const SizedBox(height: 16),
              CTextField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email,
                obscureText: false,
              ),
              CTextField(
                controller: _nameController,
                labelText: "Nama",
                prefixIcon: Icons.person,
                obscureText: false,
              ),
              CTextField(
                controller: _passwordController,
                labelText: "Password",
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              CTextField(
                controller: _passwordConfirmController,
                labelText: "Konfirmasi Password",
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              FilledButton(
                child: const Text("Daftar"),
                onPressed: () {
                  if (!_isPasswordMatch()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("password tidak sama"),
                      ),
                    );
                    return;
                  }

                  Server().register(
                    email: _emailController.text,
                    password: _passwordController.text,
                    name: _nameController.text,
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("registrasi berhasil"),
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Pagelogin(),
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
                child: const Text("Sudah punya akun? Masuk"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pagelogin(),
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
