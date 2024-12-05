import 'package:flutter/material.dart';
import 'package:pam_final_client/pages/page_login.dart';

// Command to run the app with web security disabled:
// > flutter run -d chrome --web-browser-flag "--disable-web-security"
// For more information, see https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _colorSchemeSeed = Colors.blue;
  ThemeMode _themeMode = ThemeMode.light;

  void _changeMode(String mode) {
    setState(() {
      _themeMode = mode == "dark" ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeTheme(String color) {
    setState(() {
      switch (color) {
        case "blue":
          _colorSchemeSeed = Colors.blue;
          break;
        case "green":
          _colorSchemeSeed = Colors.green;
          break;
        case "red":
          _colorSchemeSeed = Colors.red;
          break;
        case "yellow":
          _colorSchemeSeed = Colors.yellow;
          break;
        default:
          _colorSchemeSeed = Colors.blue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tugas Akhir PAM",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _colorSchemeSeed,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _colorSchemeSeed,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: PageLogin(changeMode: _changeMode, changeTheme: _changeTheme),
    );
  }
}
