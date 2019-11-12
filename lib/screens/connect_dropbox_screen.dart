import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:calibre_carte/screens/dropbox_signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> printLibs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    for (int i = 0; i < noOfCalibreLibs; i++) {
      print(sp.getString('calibre_lib_name_$i'));
    }
  }

  selectingCalibreLibrary(String name, int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      selected_calibre_lib_dir = sp.getString('calibre_lib_path_$index');
    });
    print("selecting library");
    sp.setString('selected_calibre_lib_path', selected_calibre_lib_dir);
    sp.setString('selected_calibre_lib_name', name);

    MetadataCacher().downloadAndCacheMetadata();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Hitting it');
    myFuture = loadingToken();
  }

  final url =
      'https://www.dropbox.com/oauth2/authorize?client_id=${DropboxSignIn.clientID}&response_type=token&redirect_uri=${DropboxSignIn.redirectUri}';

  @override
  Widget build(BuildContext context) {
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
                                        print(dirNames);
                                        printLibs();
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.8),
                                            context: context,
                                            builder: (BuildContext bc) {
                                              List<Widget> libraries = [];
                                              for (var i = 0;
                                                  i < dirNames.length;
                                                  i++) {
                                                libraries.add(ListTile(
                                                  title: Text(dirNames[i]),
                                                  onTap: () {
                                                    selectingCalibreLibrary(
                                                        dirNames[i], i);
                                                    Navigator.of(context).pop();
                                                  },
                                                ));
                                              }
                                              return Container(
                                                width: 300,
                                                child: Wrap(
                                                  children: libraries,
                                                ),
                                              );
                                            });
                                      },
                                    )
                                  ],
                                ),
                              ),
                        RaisedButton(
                          onPressed: () {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Refreshing..."),
                              backgroundColor: Colors.grey.withOpacity(0.7),
                            ));
                            print('Worked');
                            MetadataCacher()
                                .downloadAndCacheMetadata()
                                .then((_) {
                              MetadataCacher()
                                  .checkIfCachedFileExists()
                                  .then((exists) {
                                print(exists);
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
