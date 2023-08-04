import 'package:flutter/material.dart';
import 'package:library_tp/pages/home.dart';
import 'package:library_tp/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/app_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void loginToFirebase(BuildContext context, String email, String password) {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }).catchError((error) {
        Provider.of<ApplicationState>(context, listen: false)
            .updateMessage('Invalid Login Credentials');
      });
    } catch (error) {
      Provider.of<ApplicationState>(context, listen: false)
          .updateMessage('An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                  Provider.of<ApplicationState>(context, listen: false)
                      .updateEmail(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  Provider.of<ApplicationState>(context, listen: false)
                      .updatePassword(value);
                },
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    String email =
                        Provider.of<ApplicationState>(context, listen: false)
                            .email;
                    if (email.isNotEmpty) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      Provider.of<ApplicationState>(context, listen: false)
                          .updateMessage('Password reset email sent to $email');
                    } else {
                      Provider.of<ApplicationState>(context, listen: false)
                          .updateMessage('Please enter your email');
                    }
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        String email = Provider.of<ApplicationState>(context,
                                listen: false)
                            .email;
                        String password = Provider.of<ApplicationState>(context,
                                listen: false)
                            .password;
                        loginToFirebase(context, email, password);
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Provider.of<ApplicationState>(context, listen: false)
                      .updateIsGuest(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Continue as Guest'),
              ),
              const SizedBox(height: 16.0),
              Consumer<ApplicationState>(
                builder: (context, state, _) => Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
