import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/app_state.dart';
import 'package:library_tp/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  String selectedTheme = 'Light';
  String newPassword = '';
  String confirmPassword = '';

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
    Provider.of<ApplicationState>(context, listen: false).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _updatePassword(BuildContext context) {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      // Show an error message if any of the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the fields'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      // Show an error message if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    // Get the current user's ID from the appState
    final appState = Provider.of<ApplicationState>(context, listen: false);
    final userId = appState.userData['userId'];

    // Update the password in Firestore
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'password': newPassword,
    }).then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
        ),
      );

      // Clear the password fields after successful update
      setState(() {
        newPassword = '';
        confirmPassword = '';
      });
    }).catchError((error) {
      // Show an error message if the update fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update password'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final userData = appState.userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              if (userData.isNotEmpty) // Check if user data exists
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logged in as: ${userData["name"]}', // Display user's name
                    ),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: const Text('Logout'),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Update Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      onChanged: (value) {
                        newPassword = value; // Store the entered password
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter New Password',
                        labelText: 'New Password',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      onChanged: (value) {
                        confirmPassword = value; // Store the confirmed password
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm New Password',
                        labelText: 'Confirm Password',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => _updatePassword(context),
                      child: const Text('Update Password'),
                    ),
                  ],
                ),
              if (userData
                  .isEmpty) // If user data is empty, consider it as Guest Account
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
      ),
    );
  }
}
