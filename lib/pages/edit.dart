import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final _accNoController = TextEditingController();
  final _locationController = TextEditingController();
  final _isbnController = TextEditingController();

  Future<Map<dynamic, dynamic>> extract(String isbn) async {
    final data = <String, dynamic>{};
    final response =
        await http.get(Uri.parse("https://openlibrary.org/isbn/${isbn}.json"));
    final responseJson = json.decode(response.body);

    // Get author names properly from the original response
    final List<String> authors = [];
    for (final authorInfo in responseJson['authors'] ?? []) {
      final authorResponse = await http
          .get(Uri.parse("https://openlibrary.org${authorInfo['key']}.json"));
      final authorData = json.decode(authorResponse.body);
      authors.add(authorData['name'] ?? '');
    }

    // Dictionary for key-value assignment
    data['title'] = responseJson['title'] ?? '';
    data['image'] = "https://covers.openlibrary.org/b/isbn/${isbn}-L.jpg";
    data['authors'] = authors;
    data['publish_date'] = responseJson['publish_date'] ?? '';
    data['publishers'] = responseJson['publishers']?.isNotEmpty == true
        ? responseJson['publishers'][0]
        : '';
    data['key'] = "https://openlibrary.org${responseJson['key'] ?? ''}";
    data['subjects'] = responseJson['subjects'] ?? [];
    data['number_of_pages'] = responseJson['number_of_pages'] ?? '';
    data['isbn_10'] = responseJson['isbn_10']?.isNotEmpty == true
        ? responseJson['isbn_10'][0]
        : '';
    data['isbn_13'] = responseJson['isbn_13']?.isNotEmpty == true
        ? responseJson['isbn_13'][0]
        : '';

    return data;
  }

  void _onAddButtonPressed() async {
    String isbn = _isbnController.text;
    Map<dynamic, dynamic> bookData = await extract(isbn);

    String accNo = "TP-${_accNoController.text.toString()}";
    String location = _locationController.text;

    bookData['AccNo'] = accNo;
    bookData['Location'] = location;

    // Convert map keys to strings
    Map<String, dynamic> bookDataStringKeys = {};
    bookData.forEach((key, value) {
      bookDataStringKeys[key.toString()] = value;
    });

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('AccNo', isEqualTo: accNo)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // If the document already exists with the same AccNo, update it using set with merge option
      final docId = snapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('books')
          .doc(docId)
          .set(bookDataStringKeys, SetOptions(merge: true));
    } else {
      // If the document does not exist, add it to Firestore
      await FirebaseFirestore.instance
          .collection('books')
          .add(bookDataStringKeys);
    }

    // Show a snackbar to indicate success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Book added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center, // You can adjust the padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _accNoController,
                keyboardType: TextInputType.number, // Set numeric keyboard type
                decoration: InputDecoration(labelText: 'ACC No'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _isbnController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ISBN'),
              ),
              ElevatedButton(
                onPressed: _onAddButtonPressed,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
