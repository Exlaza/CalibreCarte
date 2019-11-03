import 'package:calibre_carte/helpers/authors_provider.dart';
import 'package:calibre_carte/helpers/books_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/screens/settings_screen.dart';
import 'package:calibre_carte/screens/dropbox_signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:calibre_carte/books_list.dart';

void main() async {
  runApp(MyApp());
  //So, that you can see an output from the database
  print((await BooksProvider.getFirstBook()).path);
  print((await AuthorsProvider.getFirstAuthor()).name);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calibre Carte",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MyHomePage(),
      routes: {
        BookDetailsScreen.routeName: (ctx) => BookDetailsScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AppBar appBar = AppBar(
      title: const Text("Calibre Carte"),
      leading: Image.asset('assets/images/calibre_logo.png', scale: 0.4));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Text("\n\n\nDrawer Is Here"),
      ),
      appBar: appBar,
      body: Container(
          height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height),
          child: BooksList()),
    );
  }
}
