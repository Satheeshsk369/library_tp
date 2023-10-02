import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_tp/app_state.dart';
import 'package:library_tp/pages/home.dart';
import 'package:library_tp/pages/book.dart';
import 'package:library_tp/pages/edit.dart';
import 'package:library_tp/pages/opac.dart';
import 'package:library_tp/pages/setting.dart';
import 'package:provider/provider.dart';

void main() {
  // Define a test widget to wrap the widget you want to test
  Widget buildTestWidget(Widget widget) {
    return MaterialApp(
      home: ChangeNotifierProvider<ApplicationState>(
        create: (context) => ApplicationState(),
        child: widget,
      ),
    );
  }

  testWidgets('HomeScreen UI Test', (WidgetTester tester) async {
    // Build the HomeScreen widget
    await tester.pumpWidget(buildTestWidget(const HomeScreen()));

    // Verify that key widgets are present
    expect(find.text('LibraryTP'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.book), findsNothing); // Assumes the book icon is not on the home screen
    // Add more tests for other widgets on the HomeScreen as needed
  });

  testWidgets('BookPage UI Test', (WidgetTester tester) async {
    // Build the BookPage widget
    await tester.pumpWidget(buildTestWidget(const BookPage()));

    // Verify that key widgets are present
    expect(find.text('Book Page'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    // Add more tests for other widgets on the BookPage as needed
  });

  testWidgets('EditPage UI Test', (WidgetTester tester) async {
    // Build the EditPage widget
    await tester.pumpWidget(buildTestWidget(EditPage()));

    // Verify that key widgets are present
    expect(find.text('Edit Page'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3)); // Assumes there are 3 text fields
    expect(find.byType(ElevatedButton), findsOneWidget);
    // Add more tests for other widgets on the EditPage as needed
  });

  testWidgets('OPACScreen UI Test', (WidgetTester tester) async {
    // Build the OPACScreen widget
    await tester.pumpWidget(buildTestWidget(OPACScreen()));

    // Verify that key widgets are present
    expect(find.text('University of Madras'), findsNWidgets(2)); // Assumes two instances are present
    expect(find.byType(SearchField), findsOneWidget);
    expect(find.byType(FilterOptionsScreen), findsOneWidget);
    // Add more tests for other widgets on the OPACScreen as needed
  });

  testWidgets('Setting UI Test', (WidgetTester tester) async {
    // Build the Setting widget
    await tester.pumpWidget(buildTestWidget(const Setting()));

    // Verify that key widgets are present
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2)); // Assumes two ElevatedButtons
    // Add more tests for other widgets on the Setting screen as needed
  });

  // Add more test cases for other screens and widgets as needed
}
