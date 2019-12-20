import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/helpers/configuration.dart';
import 'package:calibre_carte/helpers/config_loader.dart';
import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/dropbox_signin_screen.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/connect_button.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/logout_button.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class DropboxDropdown extends StatefulWidget {
//  static const clientID = 'h1csd4yy5cxl0rl';
  static const redirectUri = 'calibrecarte://dropbox';

  @override
  _DropboxDropdownState createState() => _DropboxDropdownState();
}

class _DropboxDropdownState extends State<DropboxDropdown> {
  Future myFuture;
  String dropboxEmail;
  String selected_calibre_lib_dir;
  String selected_lib_name;
  List<String> dirNames = [];
  int noOfCalibreLibs;
  bool hasChanged;
  String clientId;
  Configuration config;
  Completer<List<Widget>> _responseCompleter = Completer();

  Future<bool> loadingToken() async {
    String temp;
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey('token')) {
      dirNames.clear();
      dropboxEmail = sp.getString('dropboxEmail');
      selected_calibre_lib_dir = sp.getString('selected_calibre_lib_path');
      selected_lib_name = sp.getString('selected_calibre_lib_name');
      noOfCalibreLibs = sp.getInt('noOfCalibreLibs');
      for (int i = 0; i < noOfCalibreLibs; i++) {
        temp = sp.getString('calibre_lib_name_$i');
        dirNames.add(temp);
      }
      return true;
    }
    config = await ConfigLoader(secretPath: "dropbox.json").load();
    clientId = config.clientID;

    return false;
  }

  Future<void> deleteToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }

  Future<void> storeStringInSharedPrefs(key, val) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, val);
  }

  Future<void> storeIntInSharedPrefs(key, val) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, val);
  }

  selectingCalibreLibrary(key, val, update) {
    storeStringInSharedPrefs('selected_calibre_lib_path', key);
    storeStringInSharedPrefs('selected_calibre_lib_name', val).then((_) {
//      Navigator.of(context).pop();
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: SimpleDialog(
                    key: UniqueKey(),
                    backgroundColor: Colors.black54,
                    children: <Widget>[
                      Center(
                        child: Column(children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Updating library",
                            style: TextStyle(color: Colors.blueAccent),
                          )
                        ]),
                      )
                    ]));
          });
    });

    MetadataCacher().downloadAndCacheMetadata().then((_) {
      update.updateFlagState(true);
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print('Hitting it');
    myFuture = loadingToken();
  }

  _makePostRequest(token) async {
//    print(token);
    // set up POST request arguments
    String url = 'https://api.dropboxapi.com/2/files/search_v2';
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-type": "application/json"
    };
    String json =
        '{"query": "metadata.db", "options":{"filename_only":true, "file_extensions":["db"]}}'; // make POST request
    try {
      Response response = await post(url, headers: headers, body: json);
      return response;
    } on SocketException catch (_) {
      return null;
    }
  }

  Future<List<Widget>> refreshLibrary(
      BuildContext context, Update update, ColorTheme colorTheme) async {
//    print("Inside refresh Library for some reason");
    Map<String, String> pathNameMap = Map();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token');

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Refreshing Libraries..."),
    ));

    var response = await _makePostRequest(token);
    if (response == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No internet"),
      ));
      List<Widget> l = [
        Text(
          "No Internet",
          style: TextStyle(
            fontFamily: 'Montserrat',
//                        fontStyle: FontStyle.italic,
            fontSize: 14, color: Colors.grey,
          ),
        )
      ];
      return l;
    }
//    print("Internet check done");

    //Make a map Map<String, String> First value is the base path in lower case
    // Second Value is the name of the Folder(Library)
    // I have to convert string response.body to json
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (responseJson['matches'].length != 0) {
      responseJson['matches'].forEach((element) {
        if (element["metadata"]["metadata"]["name"] == "metadata.db") {
          String libPath = element["metadata"]["metadata"]["path_display"];
          libPath = libPath.replaceAll('metadata.db', "");
          List<String> directories =
              element["metadata"]["metadata"]["path_display"].split('/');
          String libName = directories.elementAt(directories.length - 2);
          pathNameMap.putIfAbsent(libPath, () => libName);
        }
      });
      storeIntInSharedPrefs('noOfCalibreLibs', pathNameMap.length);
      pathNameMap.keys.toList().asMap().forEach((index, path) {
        String keyName = 'calibre_lib_path_$index';
        String libName = 'calibre_lib_name_$index';
        storeStringInSharedPrefs(keyName, path);
        storeStringInSharedPrefs(libName, pathNameMap[path]);
      });
      List<Widget> columnChildren = pathNameMap.keys.toList().map((element) {
        return InkWell(
            onTap: selected_lib_name == pathNameMap[element]
                ? () {}
                : () {
                    selectingCalibreLibrary(
                        element, pathNameMap[element], update);
                    setState(() {
                      myFuture = loadingToken();
                    });
                  },
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.fromLTRB(70, 5, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.cloud_download, color: Color(0xffFED962)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        " ${pathNameMap[element]}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: colorTheme.headerText),
                      )
                    ],
                  ),
                  selected_lib_name == pathNameMap[element]
                      ? Icon(Icons.done, color: Color(0xffFED962))
                      : Container()
                ],
              ),
            ));
      }).toList();
//      columnChildren.add(SizedBox(height: 8,));
      Scaffold.of(context).removeCurrentSnackBar();
      return columnChildren;
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No libraries found"),
      ));
      return [Text("No libraries found")];
    }
  }

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    ColorTheme colorTheme = Provider.of(context);
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == false) {
            final url =
                'https://www.dropbox.com/oauth2/authorize?client_id=${clientId}&response_type=token&redirect_uri=${DropboxDropdown.redirectUri}';
            return ConnectButton(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DropboxAuthentication(
                  selectedUrl: url,
                );
              })).then((_) {
                setState(() {
                  myFuture = loadingToken();
                });
//                              update.updateFlagState(true);
              });
            });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // TODO: ADD COMPLETER TO GET LIBRARY LIST
                  RefreshButton(),
                  selected_calibre_lib_dir == null
                      ? Text("no directory selected")
                      : ExpansionTile(
                          onExpansionChanged: (bool value) {
                            if (value) {
                              setState(() {
                                if (_responseCompleter.isCompleted) {
                                  _responseCompleter = Completer();
                                }
                              });
                              _responseCompleter.complete(
                                  refreshLibrary(context, update, colorTheme));
//                        print("Getting Expansion Item ");
                            }
                          },
                          title: Card(
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.fromLTRB(30, 0, 20, 1),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.folder,
                                          color: Color(0xffFED962),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Change Library",
                                            style: TextStyle(
                                                color: colorTheme.headerText,
                                                fontFamily: 'Montserrat',
                                                fontSize: 15))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          children: <Widget>[
                            FutureBuilder(
                                future: _responseCompleter.future,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Widget>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Column(
                                      children: <Widget>[
                                        Column(
                                          children: snapshot.data,
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: <Widget>[
                                        Center(
                                          child: const Text('Loading...'),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                      ],
                                    );
                                  }
                                })
                          ],
                        ),
                  LogoutButton(() {
                    deleteToken();
                    CacheInvalidator.invalidateImagesCache();
                    CacheInvalidator.invalidateDatabaseCache();
                    setState(() {
                      myFuture = loadingToken();
                      update.changeTokenState(false);
                      update.updateFlagState(true);
                    });
                  }),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
