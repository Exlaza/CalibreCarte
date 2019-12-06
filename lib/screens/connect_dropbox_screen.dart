import 'dart:convert';

import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/dropbox_signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart';

class DropboxSignIn extends StatefulWidget {
  static const clientID = 'h1csd4yy5cxl0rl';
  static const redirectUri = 'calibrecarte://dropbox';

  @override
  _DropboxSignInState createState() => _DropboxSignInState();
}

class _DropboxSignInState extends State<DropboxSignIn> {
  Future myFuture;
  String dropboxEmail;
  String selected_calibre_lib_dir;
  List<String> dirNames = [];
  int noOfCalibreLibs;
  bool hasChanged;

  Future<bool> loadingToken() async {
    String temp;
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey('token')) {
      dirNames.clear();
      dropboxEmail = sp.getString('dropboxEmail');
      selected_calibre_lib_dir = sp.getString('selected_calibre_lib_path');
      noOfCalibreLibs = sp.getInt('noOfCalibreLibs');
      for (int i = 0; i < noOfCalibreLibs; i++) {
        temp = sp.getString('calibre_lib_name_$i');
        dirNames.add(temp);
      }
      return true;
    }

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
      Navigator.of(context).pop();
    });
    MetadataCacher().downloadAndCacheMetadata().then((_) {
      update.updateFlagState(true);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print('Hitting it');
    myFuture = loadingToken();
  }

  final url =
      'https://www.dropbox.com/oauth2/authorize?client_id=${DropboxSignIn.clientID}&response_type=token&redirect_uri=${DropboxSignIn.redirectUri}';

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
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;

    return response;
  }

  Future<List<Widget>> refreshLibrary(
      BuildContext context, Update update) async {
    Map<String, String> pathNameMap = Map();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Refreshing Libraries..."),
    ));
    _makePostRequest(token).then((response) {
      Scaffold.of(context).removeCurrentSnackBar();
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
//                        print(pathNameMap);
          }
        });
        storeIntInSharedPrefs('noOfCalibreLibs', pathNameMap.length);
        pathNameMap.keys.toList().asMap().forEach((index, path) {
          String keyName = 'calibre_lib_path_$index';
          String libName = 'calibre_lib_name_$index';
          storeStringInSharedPrefs(keyName, path);
          storeStringInSharedPrefs(libName, pathNameMap[path]);
        });
        if (pathNameMap.length > 1) {
          // First set the no of libraries in shared prefs
          // Show a pop up which displays the list of libraries
//          print('I have come inside the popup dispaly thingy');
          List<Widget> columnChildren =
              pathNameMap.keys.toList().map((element) {
            return ListTile(
                onTap: () {
                  selectingCalibreLibrary(
                      element, pathNameMap[element], update);

                  setState(() {
                    myFuture = loadingToken();
                  });
                },
                title: Text(
                  pathNameMap[element],
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                ));
          }).toList();
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
//                                        decoration: BoxDecoration(
//                                           border: Border.all(width: 2)),
                        child: Text(
                      'Select Library',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Column(children: columnChildren)
                  ],
                );
              });
        } else {
          // Her we have only one library so we make that the default
          storeStringInSharedPrefs(
            'selected_calibre_lib_path',
            pathNameMap.keys.first,
          );
          storeStringInSharedPrefs(
            'selected_calibre_lib_name',
            pathNameMap.values.first,
          ).then((_) {
//            Navigator.of(context).pop();
//          showModalBottomSheet(context: context, builder: (_){return Text("works");});
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("No other Calibre libraries found."),
            ));
          });
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("No libraries found"),
        ));
        // Show the bottom snack bar that no libraries found and Pop out of this context
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/subtle_wood.png',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Dropbox Settings"),
            backgroundColor: Colors.black.withOpacity(0.6),
          ),
          body: FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == false) {
                  return Center(
                      child: RaisedButton(
                          child: Text('Connect Dropbox'),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DropboxAuthentication(
                                selectedUrl: url,
                              );
                            })).then((_) {
                              setState(() {
                                myFuture = loadingToken();
                              });
//                              update.updateFlagState(true);
                            });
                          }));
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        selected_calibre_lib_dir == null
                            ? Text("no directory selected")
                            : Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Selected Calibre Library:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                    ),
                                    Text(selected_calibre_lib_dir),
                                    RaisedButton(
                                      child: Text("Change Directory"),
                                      onPressed: () {
                                        refreshLibrary(context, update);

//                                        Scaffold.of(context)
//                                            .showSnackBar(SnackBar(
//                                          content: Text("refreshing"),
//                                        ));
//                                        refreshLibrary(context)
//                                            .then((columnChildren) {
//                                          Scaffold.of(context)
//                                              .removeCurrentSnackBar();
//                                          showModalBottomSheet(
//                                              shape: RoundedRectangleBorder(
//                                                  borderRadius:
//                                                      BorderRadius.circular(
//                                                          5.0)),
//                                              backgroundColor:
//                                                  Colors.grey.withOpacity(0.8),
//                                              context: context,
//                                              builder: (BuildContext bc) {
//                                                return Container(
//                                                  width: 300,
//                                                  child: Wrap(
//                                                    children: columnChildren,
//                                                  ),
//                                                );
//                                              });
//                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                        RaisedButton(
                          onPressed: () {
                            update.updateFlagState(true);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Refreshing..."),
                              backgroundColor: Colors.grey.withOpacity(0.7),
                            ));
//                            print('Worked');
                            MetadataCacher()
                                .downloadAndCacheMetadata()
                                .then((_) {
                              MetadataCacher()
                                  .checkIfCachedFileExists()
                                  .then((exists) {
//                                print(exists);
                              });
                            });
                          },
                          child: Text('Refresh Library'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            deleteToken();
                            setState(() {
                              myFuture = loadingToken();
                              update.changeTokenState(false);
                            });
                          },
                          child: Text("Logout"),
                        )
                      ],
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
      ],
    );
  }
}
