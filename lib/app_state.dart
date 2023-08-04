import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  bool _isGuest = false;
  ThemeData _themeData = ThemeData(
    primarySwatch: Colors.indigo,
  );
  Map<String, dynamic> _userData =
      {}; // This will store the user data as a map.

  bool get loggedIn => _loggedIn;
  bool get isGuest => _isGuest;
  ThemeData get themeData => _themeData;
  Map<String, dynamic> get userData => _userData;

  void setLoggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  void updateIsGuest(bool newGuest) {
    _isGuest = newGuest;
    notifyListeners();
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void updateUserData(Map<String, dynamic> newData) {
    _userData = newData;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}
