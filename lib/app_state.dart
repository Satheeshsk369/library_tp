import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:library_tp/pages/login.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  String _email = '';
  String _password = '';
  String _message = '';
  bool _isguest = false;
  ThemeData _themeData = ThemeData(
    primarySwatch: Colors.indigo,
  );

  bool get loggedIn => _loggedIn;
  String get email => _email;
  String get password => _password;
  String get message => _message;
  bool get isguest => _isguest;
  ThemeData get themeData => _themeData;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  void logout(BuildContext context) {
    _loggedIn = false;
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void updateIsGuest(bool newguest) {
    _isguest = newguest;
    notifyListeners();
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
