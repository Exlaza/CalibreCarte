import 'dart:async';

import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/Books View Widgets/books_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String layout;

  TextEditingController controller = new TextEditingController();
  String filter = "";
  String sortOption = "title";
  String sortDirection = "asc";
  String token;
  Future myFuture;
  final _textUpdates = StreamController<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    TODO: Listener requires that we dispose it off when the widget terrminates
    controller.addListener(() => _textUpdates.add(controller.text));

    Observable(_textUpdates.stream)
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
        .forEach((s) {
      if ((filter != s) || (filter == "")) {
        setState(() {
          filter = s;
        });
      }
    });

    myFuture = getLayoutFromPreferences();
  }

  Future<void> getLayoutFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    layout = sp.getString('layout') ?? "list";
  }

  Future<void> storeLayout(value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('layout', value);
//    print("storing $value");
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.apps),
                  title: new Text(
                    'Layout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => {showLayouts(context)},
                ),
                ListTile(
                  leading: new Icon(Icons.sort),
                  title: new Text('Sort',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => {showSortOptions(context)},
                ),
                ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text('Settings',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => showSettings(context),
                )
              ],
            ),
          );
        });
  }

  showSettings(BuildContext context) {
    Navigator.of(context).pop();
//    Navigator.pushNamed(context, "/settings").then((_) {
////      setState(() {
////        myFuture = getTokenFromPreferences();
////      });
//    });

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SettingsNew();
    }));
  }

  void showLayouts(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text("List"),
                  onTap: () {
                    setState(() {
                      layout = "list";
                    });
                    Navigator.of(context).pop();
                    storeLayout('list');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.grid_on),
                  title: Text("Grid"),
                  onTap: () {
                    setState(() {
                      layout = "grid";
                    });
                    Navigator.of(context).pop();
                    storeLayout('grid');
                  },
                )
              ],
            ),
          );
        });
  }

  void showSortOptions(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.title),
                  title: Text("Title"),
                  onTap: () {
                    showSortDirectionOptions("title");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.alternate_email),
                  title: Text("Author Name"),
                  onTap: () {
                    showSortDirectionOptions("author");
                  },
                ),
              ],
            ),
          );
        });
  }

  void showSortDirectionOptions(String sortOpt) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.keyboard_arrow_up),
                  title: Text("Ascending"),
                  onTap: () {
                    setState(() {
                      sortOption = sortOpt;
                      sortDirection = "asc";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.keyboard_arrow_down),
                  title: Text("Descending"),
                  onTap: () {
                    setState(() {
                      sortOption = sortOpt;
                      sortDirection = "desc";
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget closeButton() {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        _appBarTitle = Text(
          "Calibre Carte",
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        );
        controller.clear();
      },
    );
  }

  void _searchPressed(String searchFil) {
    setState(() {
      _appBarTitle = new TextField(
        style: TextStyle(color: Colors.white),
        autofocus: true,
        controller: controller,
        decoration: new InputDecoration(
            prefixIcon: closeButton(), hintText: 'Search for ${searchFil}s'),
      );
    });
  }

  Widget _appBarTitle = const Text(
    "Calibre Carte",
    style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    String searchFilter = update.searchFilter;
    ColorTheme colortheme = Provider.of(context);
//    print("rebuilding homepage");
    return Container(
      child: Scaffold(
          backgroundColor: colortheme.descriptionBackground,
          appBar:
              AppBar(backgroundColor: Color(0xff002242), title: _appBarTitle,
//              leading:
                  actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _searchPressed(searchFilter);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                ),
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
//                    update.updateFlagState(true);
//                  },
//                )
              ]),
          body: FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (update.tokenExists == true) {
                    return BooksView(
                      layout,
                      filter,
                      sortDirection: sortDirection,
                      sortOption: sortOption,
                      update: update,
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Please Connect to dropbox',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: colortheme.headerText),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
