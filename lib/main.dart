import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool tokenExists;
  String searchFilter;
  Future myFuture;

  Future<void> getTokenAndSearchFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    tokenExists = sp.containsKey('token');
    searchFilter = sp.getString('searchFilter') ?? 'title';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getTokenAndSearchFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
//    print("REBUILDING APP");
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            builder: (_) => Update(tokenExists, searchFilter),
            child: MaterialApp(
              title: "Calibre Carte",
              theme: ThemeData(primarySwatch: Colors.blueGrey),
              home: MyHomePage(),
              routes: {
                BookDetailsScreen.routeName: (ctx) => BookDetailsScreen(),
                Settings.routeName: (ctx) => Settings()
              },
            ),
          );
        } else {
          return Container(
              color: Colors.white, child: CircularProgressIndicator());
        }
      },
    );
  }
}
