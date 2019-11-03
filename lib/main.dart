import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/screens/settings_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
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
        Settings.routeName: (ctx)=>Settings()
      },
    );
  }
}

