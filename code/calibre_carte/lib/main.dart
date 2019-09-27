import 'package:calibre_carte/books_list.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: Scaffold(
        endDrawer: new Drawer(
          child: new Text("\n\n\nDrawer Is Here"),
        ),
        //backgroundColor: Color(0xffd1eeee),
        appBar: AppBar(
          title: Text("Calibre Carte"),
          leading:
          new Image.asset('lib/assets/images/calibre_logo.png', scale: 0.4),
//          actions: <Widget>[
//            new IconButton(
//              icon: new Icon(
//                Icons.settings,
//                color: Colors.white,
//              ),
//              onPressed: null,
//            )
//          ],
        ),
        body: BooksList(),
      ),
    );
  }
}
