import 'package:flutter/material.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  String _selectedMode = "light";
  String _selectedTheme = "blue";
  String _selectedTimezone = "wib";
  String _selectedCurrency = "idr";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: const Text("Mode"),
              subtitle: const Text("Pilih mode aplikasi"),
              trailing: DropdownButton(
                items: const [
                  DropdownMenuItem(value: "light", child: Text("Terang")),
                  DropdownMenuItem(value: "dark", child: Text("Gelap")),
                ],
                value: _selectedMode,
                onChanged: (value) {
                  setState(() {
                    _selectedMode = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Tema"),
              subtitle: const Text("Pilih tema aplikasi"),
              trailing: DropdownButton(
                items: const [
                  DropdownMenuItem(
                    value: "blue",
                    child: Text(
                      "Biru",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "red",
                    child: Text(
                      "Hijau",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "green",
                    child: Text(
                      "Merah",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "yellow",
                    child: Text(
                      "Kuning",
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ],
                value: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Zona Waktu"),
              subtitle: const Text("Pilih zona waktu aplikasi"),
              trailing: DropdownButton(
                items: const [
                  DropdownMenuItem(value: "wib", child: Text("WIB")),
                  DropdownMenuItem(value: "wita", child: Text("WITA")),
                  DropdownMenuItem(value: "wit", child: Text("WIT")),
                  DropdownMenuItem(value: "london", child: Text("London")),
                ],
                value: _selectedTimezone,
                onChanged: (value) {
                  setState(() {
                    _selectedTimezone = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Mata Uang"),
              subtitle: const Text("Pilih mata uang aplikasi"),
              trailing: DropdownButton(
                items: const [
                  DropdownMenuItem(value: "idr", child: Text("IDR")),
                  DropdownMenuItem(value: "usd", child: Text("USD")),
                  DropdownMenuItem(value: "eur", child: Text("EUR")),
                  DropdownMenuItem(value: "jpy", child: Text("JPY")),
                  DropdownMenuItem(value: "gbp", child: Text("GBP")),
                ],
                value: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value.toString();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
