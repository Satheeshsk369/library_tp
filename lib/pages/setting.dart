import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/app_state.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  String selectedTheme = 'Light';
  bool _loggedIn = false;

  void onThemeChanged(String? value) {
    // Update the theme based on the selected option
    if (value == 'Light') {
      setTheme(ThemeData(primarySwatch: Colors.indigo));
    } else if (value == 'Dark') {
      setTheme(ThemeData(
        primaryColor: Colors.indigo,
        brightness: Brightness.dark,
      ));
    }
  }

  void setTheme(ThemeData themeData) {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    appState.setThemeData(themeData);
  }

  void _logout(BuildContext context) {
    Provider.of<ApplicationState>(context, listen: false).logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    _loggedIn = appState.loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DropdownButton<String>(
              value: selectedTheme,
              onChanged: (value) => onThemeChanged(value),
              items: <String>['Light', 'Dark']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (_loggedIn)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logged in as: ${appState.email}'),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            if (!_loggedIn)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Logged in as: Guest Account'),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
