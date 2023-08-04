import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/pages/home.dart';
import 'package:library_tp/pages/login.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          if (appState.loggedIn) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
