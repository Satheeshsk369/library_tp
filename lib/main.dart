import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/pages/home.dart';
import 'package:library_tp/pages/login.dart';
import 'app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => const LibraryTP(),
  ));
}

class LibraryTP extends StatelessWidget {
  const LibraryTP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibraryTP',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ApplicationState>(context).themeData,
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          if (appState.isGuest) {
            return const HomeScreen();
          } else if (appState.loggedIn) {
            // Add your logic here for handling the logged-in user.
            // For now, let's redirect to the login screen.
            return const LoginScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
