import 'package:flutter/material.dart';
import 'package:pam_final_client/pages/page_login.dart';

/* Tugas Akhir Pemrograman Aplikasi Mobile SI-A
 * Dibuat oleh Rifqi Daiva Tri Nandhika
 * NIM: 124220131
 */

// Command to run the app with web security disabled:
// > flutter run -d chrome --web-browser-flag "--disable-web-security"
// For more information, see https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
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
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      home: const Pagelogin(),
    );
  }
}
