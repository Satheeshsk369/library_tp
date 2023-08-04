import 'package:flutter/material.dart';
import 'package:library_tp/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:library_tp/app_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void loginToFirebase(
      BuildContext context, String rollNumber, String password) {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    String hashedPassword = _hashPassword(password);

    usersCollection
        .where('rollNumber', isEqualTo: rollNumber)
        .where('password', isEqualTo: hashedPassword)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size == 1) {
        // Login successful, update the user data in ApplicationState
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Provider.of<ApplicationState>(context, listen: false)
            .updateUserData(userData);

        // Set loggedIn to true
        Provider.of<ApplicationState>(context, listen: false).setLoggedIn(true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid Login Credentials'),
          duration: Duration(seconds: 2),
        ));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred'),
        duration: Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    String rollNumber = '';
    String password = '';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/university_logo.png',
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.4,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "University of Madras",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Department of Theoretical Physics",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  rollNumber = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Roll Number',
                  labelText: 'Roll Number',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Continue as Guest
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text('Continue as Guest'),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        loginToFirebase(context, rollNumber, password);
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
              // ... remaining UI content ...
            ],
          ),
        ),
      ),
    );
  }
}
