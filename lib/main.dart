import 'dart:io';
import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/localisation/calibre_carte_localisation.dart';
import 'package:calibre_carte/localisation/localisation_utils.dart';
import 'package:calibre_carte/providers/book_details_navigation_provider.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override

  static void setLocale(BuildContext context, Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool tokenExists;
  String searchFilter;
  Future myFuture;
  bool darkMode;
  Locale _locale;

  void setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  Future<void> getTokenAndSearchFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    darkMode = sp.getBool('darkMode') ?? false;
    tokenExists = sp.containsKey('token');
    searchFilter = sp.getString('searchFilter') ?? 'title';

    _locale = await getLocale();

    //    Set the default download directory here once if it not set already
    if (!sp.containsKey("downloaded_directory")) {
      Directory defaultDownloadDirectory = await getExternalStorageDirectory();
//      Creating books if that doesn't exist
      if (!Directory("${defaultDownloadDirectory.path}/books").existsSync()) {
        Directory("${defaultDownloadDirectory.path}/books")
            .createSync(recursive: true);
      }

      sp.setString(
          "downloaded_directory", defaultDownloadDirectory.path + "/books");
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
              locale: _locale,
              title: "Calibre Carte",
              home: MyHomePage(),
              supportedLocales: [
                Locale('en', 'US'),
                Locale('hi', 'IN')
              ],
              localizationsDelegates: [
                CalibreCarteLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode){
                    return deviceLocale;
                  }
                }

                return supportedLocales.first;

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
