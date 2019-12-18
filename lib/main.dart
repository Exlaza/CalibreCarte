import 'dart:io';
import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/providers/book_details_navigation_provider.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool darkMode;

  Future<void> getTokenAndSearchFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    darkMode = sp.getBool('darkMode');
    tokenExists = sp.containsKey('token');
    searchFilter = sp.getString('searchFilter') ?? 'title';
//    Set the default download directory here once if it not set already
    if (!sp.containsKey("downloaded_directory")) {
      Directory defaultDownloadDirectory = await getExternalStorageDirectory();
//      Creating books if that doesn't exist
      if (!Directory("${defaultDownloadDirectory.path}/books").existsSync()) {
        Directory("${defaultDownloadDirectory.path}/books")
            .createSync(recursive: true);
      }

      sp.setString(
          "download_directory", defaultDownloadDirectory.path + "/books");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<Map<PermissionGroup, PermissionStatus>> permissions =
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
    myFuture = getTokenAndSearchFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Update(tokenExists, searchFilter),
              ),
              ChangeNotifierProvider(
                create: (_) => BookDetailsNavigation(),
              ),
              ChangeNotifierProvider(
                create: (_) => ColorTheme(darkMode),
              )
            ],
            child: MaterialApp(
              title: "Calibre Carte",
              theme: ThemeData(
                  primaryColor: Color(0xffFED962),
                  textTheme: TextTheme(subtitle: TextStyle(
                      color: darkMode == true ? Colors.white:Colors.black)),
                  dividerColor: Colors.transparent),
              home: MyHomePage(),
              routes: {
                BookDetailsScreen.routeName: (ctx) => BookDetailsScreen(),
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
