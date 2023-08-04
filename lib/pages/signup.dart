import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/app_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  String rollNo = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String message = '';

  void signUpToFirebase(BuildContext context) {
    if (password != confirmPassword) {
      setState(() {
        message = 'Password and Confirm Password do not match';
      });
      return;
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      final applicationState =
          Provider.of<ApplicationState>(context, listen: false);
      applicationState.updateEmail(email);
      applicationState.updatePassword(password);

      setState(() {
        message = 'Sign Up Successfully';
      });
    }).catchError((error) {
      setState(() {
        message = 'Sign Up Failed: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  rollNo = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter RollNo',
                  labelText: 'RollNo',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                  labelText: 'Email',
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
              TextField(
                onChanged: (value) {
                  confirmPassword = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  signUpToFirebase(context);
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16.0),
              Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
