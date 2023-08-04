import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_tp/app_state.dart';
import 'package:library_tp/pages/book.dart';
import 'package:library_tp/pages/edit.dart';
import 'package:library_tp/pages/opac.dart';
import 'package:library_tp/pages/setting.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final applicationState = Provider.of<ApplicationState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LibraryTP'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(""),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Do nothing, since we're already on the Home screen.
                Navigator.pop(context); // Close the drawer
              },
            ),
            if (applicationState.loggedIn)
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Books'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookPage()),
                  );
                },
              ),
            if (applicationState.loggedIn)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditPage()),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              },
            ),
          ],
        ),
      ),
      body: OPACScreen(),
    );
  }
}
