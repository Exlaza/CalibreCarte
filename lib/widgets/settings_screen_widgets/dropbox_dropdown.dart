import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/helpers/configuration.dart';
import 'package:calibre_carte/helpers/config_loader.dart';
import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:calibre_carte/helpers/oauth_helper.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/dropbox_signin_screen.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/connect_button.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/logout_button.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;

class DropboxDropdown extends StatefulWidget {
//  static const clientID = 'h1csd4yy5cxl0rl';
  static const redirectUriCode = 'calibrecarte://dropbox';
  static const redirectUriToken = 'calibrecarte://dropbox/token';

  @override
  _DropboxDropdownState createState() => _DropboxDropdownState();
}

class _DropboxDropdownState extends State<DropboxDropdown> {
  Future myFuture;
  String dropboxEmail;
  String selected_calibre_lib_dir;
  String selected_lib_name;
  String token;
  List<String> dirNames = [];
  int noOfCalibreLibs;
  bool hasChanged;
  String clientId;
  Configuration config;
  StreamSubscription _sub;

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

  _makePostRequest(token) async {
    print("post request started");
//    print(token);
    // set up POST request arguments
    String url = 'https://api.dropboxapi.com/2/files/search_v2';
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-type": "application/json"
    };
    String json =
        '{"query": "metadata.db", "options":{"filename_only":true, "file_extensions":["db"]}}'; // make POST request
    try{
    Response response = await post(url, headers: headers, body: json);
    print("i have the response");
    int statusCode = response.statusCode;
    String body = response.body;
    print("post request ended");
    return response;}
    catch(e){
      return null;
    }

  }

  _makePostRequestCode(code) async {
//    print(token);
    // set up POST request arguments
    String url = 'https://api.dropbox.com/oauth2/token';
//    Map<String, String> headers = {
//      "Content-type": "application/json"
//    };
    print(code);
    Map<String, dynamic> json = {"code":code, "redirect_uri": DropboxDropdown.redirectUriCode, "grant_type":"authorization_code", "code_verifier":OAuthUtils.codeVerifier, "client_id":clientId} ; // make POST request

    Response response = await post(url, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    return response;
  }

  selectingCalibreLibrary(key, val, update) {

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


    MetadataCacher().downloadAndCacheMetadata(path:key).then((value) {
      if(value==true){
        storeStringInSharedPrefs('selected_calibre_lib_path', key);
        storeStringInSharedPrefs('selected_calibre_lib_name', val);
        update.updateFlagState(true);
      }
      Navigator.of(context).pop();
    });
  }

  _showLoading(BuildContext context) {
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
                          "Loading Calibre library",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }

  selectingCalibreLibraryNew(key, val, update, token) {
    storeStringInSharedPrefs('selected_calibre_lib_path', key);
    storeStringInSharedPrefs('selected_calibre_lib_name', val);
    MetadataCacher().downloadAndCacheMetadata(token:token).then((val) {
      if (val == true) {
//        print("storing token");
        storeStringInSharedPrefs('token', token);
//        print("stored token");
        update.changeTokenState(true);
        update.updateFlagState(true);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  _launchURL(String url) async {
//    print(await canLaunch(url));
    if (await canLaunch(url)) {
//      print('url');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> initUniLinks() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      //Although this is not needed now, but Google actually recommends against using a webview for,
      //So assuming in future we need to do it the url_launcher way then we would have to use this method
      print(link);
      if (link.startsWith(DropboxDropdown.redirectUriCode)){

        Update update = Provider.of<Update>(context, listen: false);

        var uri = Uri.parse(link);
        // Step 1. Parse the token
        String code;

        uri.queryParameters.forEach((k, v) {
          if (k == "code") {
            code = v;
          }

        });

        print("hohohohoohoho");
        print(code);

        _makePostRequestCode(code).then((response){
          Map<String, dynamic> responseJson = jsonDecode(response.body);
          token = responseJson['access_token'];
          print(responseJson);

          Map<String, String> pathNameMap = Map();
          _makePostRequest(token).then((response) {
            //Make a map Map<String, String> First value is the base path in lower case
            // Second Value is the name of the Folder(Library)
            // I have to convert string response.body to json
            Map<String, dynamic> responseJson = jsonDecode(response.body);
            if (responseJson['matches'].length != 0) {
              responseJson['matches'].forEach((element) {
                if (element["metadata"]["metadata"]["name"] ==
                    "metadata.db") {
                  String libPath =
                  element["metadata"]["metadata"]["path_display"];
                  libPath = libPath.replaceAll('metadata.db', "");
                  List<String> directories = element["metadata"]
                  ["metadata"]["path_display"]
                      .split('/');
                  String libName =
                  directories.elementAt(directories.length - 2);
                  pathNameMap.putIfAbsent(libPath, () => libName);
//                        print(pathNameMap);
                }
              });
              storeIntInSharedPrefs(
                  'noOfCalibreLibs', pathNameMap.length);
              pathNameMap.keys.toList().asMap().forEach((index, path) {
                String keyName = 'calibre_lib_path_$index';
                String libName = 'calibre_lib_name_$index';
                storeStringInSharedPrefs(keyName, path);
                storeStringInSharedPrefs(libName, pathNameMap[path]);
              });

              // TODO: Default selection
              storeStringInSharedPrefs(
                'selected_calibre_lib_path',
                pathNameMap.keys.first,
              );
              storeStringInSharedPrefs(
                'selected_calibre_lib_name',
                pathNameMap.values.first,
              );
              if (pathNameMap.length > 1) {
                // First set the no of libraries in shared prefs
                // Show a pop up which displays the list of libraries
//                      print('I have come inside the popup dispaly htingy');
                List<Widget> columnChildren =
                pathNameMap.keys.toList().map((element) {
                  return InkWell(
                      onTap: () {
                        _showLoading(context);
                        selectingCalibreLibraryNew(
                            element, pathNameMap[element], update, token);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.folder,
                              color: Color(0xffFED962),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              pathNameMap[element],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff002242)),
                            )
                          ],
                        ),
                      ));
                }).toList();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () async {
                          _showLoading(context);
                          await MetadataCacher()
                              .downloadAndCacheMetadata(token:token)
                              .then((val) {
                            if (val == true) {
                              storeStringInSharedPrefs('token', token);
                              update.changeTokenState(true);
                              update.updateFlagState(true);
                            }
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                          return true;
                        },
                        child: AlertDialog(
                          contentPadding: EdgeInsets.all(10),
                          content: Container(
                            width: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                      'Select Library',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff002242)),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(children: columnChildren)
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                _showLoading(context);
                storeStringInSharedPrefs('selected_calibre_lib_path', pathNameMap.keys.first);
                storeStringInSharedPrefs('selected_calibre_lib_name', pathNameMap.values.first);
                MetadataCacher().downloadAndCacheMetadata(token:token).then((val) {
                  if (val == true) {
//                          print("storing token");
                    storeStringInSharedPrefs('token', token);
//                          print("stored token");
                    update.changeTokenState(true);
                    update.updateFlagState(true);
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
                // Her we have only one library so we make that the default
              }
            } else {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("No Calibre libraries found"),));
              Navigator.of(context)
                  .pop();
              // Show the bottom snack bar that no libraries found and Pop out of this context
            }
          });


        });
      }
      //So, just keeping it here.
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  //Let's try and figure out if I can attach a listener and then parse and do something when I finally get a URL back


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUniLinks();
    //    print('Hitting it');
    myFuture = loadingToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sub.cancel();
  }



//  _makePostRequest(token) async {
////    print(token);
//    // set up POST request arguments
//    String url = 'https://api.dropboxapi.com/2/files/search_v2';
//    Map<String, String> headers = {
//      "Authorization": "Bearer $token",
//      "Content-type": "application/json"
//    };
//    String json =
//        '{"query": "metadata.db", "options":{"filename_only":true, "file_extensions":["db"]}}'; // make POST request
//    try {
//      Response response = await post(url, headers: headers, body: json);
//      return response;
//    } on SocketException catch (_) {
//      return null;
//    }
//  }

  Future<List<Widget>> refreshLibrary(
      BuildContext context, Update update, ColorTheme colorTheme) async {
//    print("Inside refresh Library for some reason");
    Map<String, String> pathNameMap = Map();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token');

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Refreshing Libraries..."),
    ));
    print("before post request");
    var response = await _makePostRequest(token);
    print("after post request");
    print("starting internet check");
    if (response == null) {
      print("response null no internet here");
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
    print("Internet check done");

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
  Future<bool> checkNet() async {
    try {
      var result = await InternetAddress.lookup('www.google.com');
//      print("internet is $result");
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
//    BuildContext oldContext = context;
    ColorTheme colorTheme = Provider.of(context);
    print(OAuthUtils.codeVerifier);
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == false) {
            final codeChallenge = OAuthUtils.generateAndEncodeCodeChallenge();

            final url =
                'https://www.dropbox.com/oauth2/authorize?client_id=${clientId}&response_type=code&redirect_uri=${DropboxDropdown.redirectUriCode}&code_challenge=$codeChallenge&code_challenge_method=${OAuthUtils.codeChallengeMethod}';
            return ConnectButton(() {
              checkNet().then((val){
                if(val==false){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("No internet"),));
                }
                else{
                  _launchURL(url);

//                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                    return DropboxAuthentication(
//                      selectedUrl: url, oldContext: oldContext,
//                    );
//                  })).then((_) {
//                    setState(() {
//                      myFuture = loadingToken();
//                    });
////                              update.updateFlagState(true);
//                  });
                }
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
                              print("tile explanding");
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
