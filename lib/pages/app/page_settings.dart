import 'package:flutter/material.dart';
import 'package:pam_final_client/instances/server.dart';

class PageSettings extends StatefulWidget {
  final void Function(String) changeMode;
  final void Function(String) changeTheme;

  const PageSettings({
    super.key,
    required this.changeMode,
    required this.changeTheme,
  });

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  // Default selected settings
  String _selectedMode = "light";
  String _selectedTheme = "blue";
  String _selectedTimezone = "wib";
  String _selectedCurrency = "idr";
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();

    // Get the selected settings
    Server().getPreferences(
      onSuccess: (preferences) {
        setState(() {
          _selectedMode = preferences.mode;
          _selectedTheme = preferences.theme;
          _selectedTimezone = preferences.timeZone;
          _selectedCurrency = preferences.currency;
          _isPremium = preferences.isPremium;
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
                    value: "green",
                    child: Text(
                      "Hijau",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "red",
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
            // ListTile(
            //   title: const Text("Mata Uang"),
            //   subtitle: const Text("Pilih mata uang aplikasi"),
            //   trailing: DropdownButton(
            //     items: const [
            //       DropdownMenuItem(value: "idr", child: Text("IDR")),
            //       DropdownMenuItem(value: "usd", child: Text("USD")),
            //       DropdownMenuItem(value: "eur", child: Text("EUR")),
            //       DropdownMenuItem(value: "jpy", child: Text("JPY")),
            //       DropdownMenuItem(value: "gbp", child: Text("GBP")),
            //     ],
            //     value: _selectedCurrency,
            //     onChanged: (value) {
            //       setState(() {
            //         _selectedCurrency = value.toString();
            //       });
            //     },
            //   ),
            // ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Server().updatePreferences(
                  preferences: Preferences(
                    mode: _selectedMode,
                    theme: _selectedTheme,
                    timeZone: _selectedTimezone,
                    currency: _selectedCurrency,
                    isPremium: _isPremium,
                  ),
                  onSuccess: () {
                    widget.changeMode(_selectedMode);
                    widget.changeTheme(_selectedTheme);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pengaturan berhasil disimpan"),
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
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
