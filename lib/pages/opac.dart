import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class OPACScreen extends StatefulWidget {
  @override
  _OPACScreenState createState() => _OPACScreenState();
}

class _OPACScreenState extends State<OPACScreen> {
  String _searchText = '';
  String _filterOption = "Any";

  void _onSearchTextChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  void _onFilterOptionChanged(String value) {
    setState(() {
      _filterOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              const Text(
                "University of Madras",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Department of Theoretical Physics",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SearchField(
                onSearchTextChanged: _onSearchTextChanged,
              ),
              const SizedBox(height: 8),
              FilterOptionsScreen(
                onFilterOptionChanged: _onFilterOptionChanged,
              ),
              const SizedBox(height: 8),
              BookGridView(
                query: _searchText,
                filter: _filterOption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookGridView extends StatelessWidget {
  final String query;
  final String filter;

  const BookGridView({required this.query, required this.filter});

  Stream<QuerySnapshot<Map<String, dynamic>>> _getBookStream() {
    // Stream the 'books' collection from Firestore
    Stream<QuerySnapshot<Map<String, dynamic>>> bookStream =
        FirebaseFirestore.instance.collection('books').snapshots();
    return bookStream;
  }

  List<Map<dynamic, dynamic>> _applyFilter(
      List<Map<dynamic, dynamic>> bookDataList) {
    if (filter == "Any") {
      return bookDataList;
    } else {
      return bookDataList.where((bookData) {
        String? fieldValue = bookData[filter]?.toString().toLowerCase();
        return fieldValue != null;
      }).toList();
    }
  }

  List<Map<dynamic, dynamic>> _applySearch(
      List<Map<dynamic, dynamic>> bookDataList, String query) {
    if (query.isEmpty) {
      return bookDataList;
    } else {
      return bookDataList.where((bookData) {
        String dataString = bookData.toString().toLowerCase();
        return dataString.contains(query.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = (MediaQuery.of(context).size.width ~/ 350);
    if (crossAxisCount == 0) {
      crossAxisCount = 1; // Set it to 1 if it's zero
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _getBookStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          List<Map<dynamic, dynamic>> bookDataList =
              snapshot.data!.docs.map((doc) => doc.data()).toList();

          // Filter the bookDataList based on the selected filter option
          bookDataList = _applyFilter(bookDataList);

          // Apply the search query to the filtered bookDataList
          List<Map<dynamic, dynamic>> searchResults =
              _applySearch(bookDataList, query);

          return GridView.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.666,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            children: searchResults.map((bookData) {
              return BookCardWidget(bookData: bookData);
            }).toList(),
          );
        }
      },
    );
  }
}

// Rest of the code remains unchanged

class BookCardWidget extends StatelessWidget {
  final Map<dynamic, dynamic> bookData;

  const BookCardWidget({required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
              child: Image.network(
            bookData['image'],
            height: 150,
            width: 100,
            fit: BoxFit.cover,
          )),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Acc No: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['AccNo'] ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Title: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['title'] ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Authors: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['authors'].join(', ')),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Publish Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['publish_date']),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Publishers: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['publishers']),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Location: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['Location'] ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Subjects: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['subjects'].join(', ')),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Number of Pages: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['number_of_pages'].toString()),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'ISBN-10: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['isbn_10'].toString()),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                const TextSpan(
                  text: 'ISBN-13: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: bookData['isbn_13'].toString()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookWebView(link: bookData["key"]),
                ),
              );
            },
            child: const Text("Open Library URL"),
          ),
        ],
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
        title: const Text("Open Library"),
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

class SearchField extends StatefulWidget {
  final Function(String) onSearchTextChanged;

  const SearchField({required this.onSearchTextChanged});

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  String searchText = '';

  void _performSearch() {
    widget.onSearchTextChanged(searchText);
    // Here, you can implement your search logic using the searchText value
    // For now, let's just print the search text
    print('Performing search: $searchText');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      width: 700 * MediaQuery.of(context).size.aspectRatio,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              onSubmitted: (value) {
                _performSearch();
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
      ),
    );
  }
}

class FilterOptionsScreen extends StatefulWidget {
  final Function(String) onFilterOptionChanged;

  const FilterOptionsScreen({required this.onFilterOptionChanged});

  @override
  FilterOptionsScreenState createState() => FilterOptionsScreenState();
}

class FilterOptionsScreenState extends State<FilterOptionsScreen> {
  String? selectedOption = "Any";
  List<String> options = [
    "Any",
    "Title",
    "Acc No",
    "Author",
    "Location",
    "Publisher",
    "Publish Date",
    "Subjects",
    "ISBN 10",
    "ISBN 13",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 600 * MediaQuery.of(context).size.aspectRatio,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Text("Filter Option",
              style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption = newValue;
                widget.onFilterOptionChanged(selectedOption!);
              });
            },
            items: options.map<DropdownMenuItem<String>>((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          )
        ]));
  }
}
