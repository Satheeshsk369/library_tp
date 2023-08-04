import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('links').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final link = books[index]['link'];
              final name = books[index]['name'];

              return ListTile(
                title: Text('$name'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookWebView(link: link),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BookWebView extends StatefulWidget {
  final String link;

  const BookWebView({required this.link, super.key});

  @override
  State<BookWebView> createState() => _BookWebViewState();
}

class _BookWebViewState extends State<BookWebView> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.link)),
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        onLoadStart: (controller, url) {
          // Handle page start loading
        },
        onLoadStop: (controller, url) {
          // Handle page finish loading
        },
        onLoadError: (controller, url, code, message) {
          // Handle error if any
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url;
          if (url.toString().startsWith('https://www.youtube.com/')) {
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
