import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class DropboxAuthentication extends StatefulWidget {
  final String selectedUrl;

  DropboxAuthentication({
    @required this.selectedUrl,
  });

  @override
  _DropboxAuthenticationState createState() =>
      _DropboxAuthenticationState(selectedUrl);
}

class _DropboxAuthenticationState extends State<DropboxAuthentication> {
  final url;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoadingPage;
  final key = UniqueKey();
  num _stackToView = 1;

  StreamSubscription _sub;

  _makePostRequest(token) async {
    print(token);
    // set up POST request arguments
    String url = 'https://api.dropboxapi.com/2/files/search_v2';
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-type": "application/json"
    };
    String json =
        '{"query": "metadata.db", "options":{"filename_only":true, "file_extensions":["db"]}}'; // make POST request
    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result
    int statusCode = response
        .statusCode; // this API passes back the id of the new item added to the body
    String body = response.body;
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }}
    return response;
  }

  Future<Null> initUniLinks() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      //Althouhg this is not needed now, but Google actually recommends against using a webview for,
      //So assuming in future we need to do it the url_launcher way then we would have to use this method
      print(link);
      //So, just keeping it here.
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  //Let's try and figure out if I can attach a listener and then parse and do something when I finally get a URL back

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sub.cancel();
  }

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  _DropboxAuthenticationState(this.url);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoadingPage = true;
    initUniLinks();
  }

  _launchURL(String url) async {
    print(await canLaunch(url));
    if (await canLaunch(url)) {
      print('url');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> storeStringInSharedPrefs(key, val) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, val);
  }

  Future<void> storeIntInSharedPrefs(key, val) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, val);
  }

  selectingCalibreLibrary(key, val) {
    storeStringInSharedPrefs('selected_calibre_lib_path', key);
    storeStringInSharedPrefs('selected_calibre_lib_name', val).then((_){
      Navigator.of(context).pop();
    });
    MetadataCacher().downloadAndCacheMetadata().then((_) {
      Navigator.of(context).pop();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropbox Login'),
      ),
      body: IndexedStack(
        index: _stackToView,
        children: <Widget>[
          WebView(
            key: key,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.selectedUrl,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('calibrecarte://dropbox')) {
                _launchURL(request.url);
                //Here you parse the url and get back the token value and send it wherever or store it in some state
                //List opf things to do
                // 1. Parse the token from the url. 2. Store the token in shared prefs
                // 3. Do a search for calibre libs
                // 4. Store all the information on calibre libs like number, and paths
                // 5. If less than 1, make that the selected lib and pop this page
                // 6. If more than 1, display a popUp telling the user to choose a default one
                // 7. When user has selected the library to show, store the information in calibre_selcted_lib
                // 8. Finally pop this page
                var uri = Uri.parse(request.url);
                // Step 1. Parse the token
                String token;
                var tempUri = Uri.parse('http://test.com?${uri.fragment}');
                tempUri.queryParameters.forEach((k, v) {
                  print(k);
                  if (k == "access_token") {
                    token = v;
                  }
                });
                // Step 2: Storing token in shared prefs. Remember this is async so, the next statement would be executed immediately
                storeStringInSharedPrefs('token', token);
                // Step 3 Make a call to search for calibre libs
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
                        String lowerCasePath =
                            element["metadata"]["metadata"]["path_display"];
                        List<String> directories = element["metadata"]
                                ["metadata"]["path_display"]
                            .split('/');
                        String libName =
                            directories.elementAt(directories.length - 2);
                        pathNameMap.putIfAbsent(lowerCasePath, () => libName);
                        print(pathNameMap);
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
//                    TODO: Change this to > 1
                    if (pathNameMap.length == 1) {
                      // First set the no of libraries in shared prefs
                      // Show a pop up which displays the list of libraries
                      print('I have come inside the popup dispaly htingy');
                      List<Widget> columnChildren =
                          pathNameMap.keys.toList().map((element) {
                        return InkWell(
                            onTap: () {selectingCalibreLibrary(element, pathNameMap[element]);},
                            child: Text(
                              pathNameMap[element],
                              style: TextStyle(fontSize: 30),
                            ));
                      }).toList();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32),
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              content: Container(
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 2)),
                                        child: Text(
                                          'Select Library',
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(children: columnChildren)
                                  ],
                                ),
                              ),
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
                      ).then((_){
                        Navigator.of(context).pop();
                      });
                    }
                  } else {
                    // Show the bottom snack bar that no libraries found and Pop out of this context
                  }
                });
//                Navigator.pop(context);
                return NavigationDecision.prevent;
              }

              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageFinished: _handleLoad,
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
