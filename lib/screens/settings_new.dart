import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/connect_dropbox_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNew extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsNewState createState() => _SettingsNewState();
}

class _SettingsNewState extends State<SettingsNew> {
  SharedPreferences _prefs;
  bool darkMode;
  Future myFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = SharedPreferences.getInstance();
    myFuture.then((sp) {
      _prefs = sp;
      darkMode = sp.getBool('darkMode') ?? false;
    });
  }

  void saveBoolToSharedPrefs(String settingName, bool val) {
    _prefs.setBool(settingName, val);
  }

  void saveStringToSP(String settingName, String val) {
    _prefs.setString(settingName, val);
  }

  Widget _settingsCard(settingName, settingIcon, Function onClicked) {
    return Card(
      elevation: 0.0,
      child: InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(settingName,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
                  Icon(
                    settingIcon,
                    color: Color(0xffFED962),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingGroup(groupName) {
    return Container(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          groupName,
          style: TextStyle(
              fontFamily: 'Montserrat', color: Colors.grey, fontSize: 25),
        ));
  }

  @override
  Widget build(BuildContext context) {
//    print('Building asettings for no reason');
    Update update = Provider.of(context);
    Widget loadingWidget = Center(
      child: CircularProgressIndicator(),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff002242),
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
//                print('THe connection finished now');
            return Container(
              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _settingGroup("Cloud"),
                  _settingsCard('Dropbox',
                      update.tokenExists ? Icons.cloud_done : Icons.cloud_off,
                      () {
//                            print('Tap is not working');
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DropboxSignIn();
                    }));
                  }),
                  _settingGroup("Search"),
                  Consumer<Update>(
                    builder: (ctx, update, child) => Card(
                      elevation: 0.0,
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              backgroundColor: Colors.grey.withOpacity(0.8),
                              context: context,
                              builder: (_) {
                                return Container(
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Author"),
                                        onTap: () {
                                          saveStringToSP(
                                              'searchFilter', 'author');
                                          update.changeSearchFilter('author');
                                        },
                                      ),
                                      ListTile(
                                        title: Text("Book Title"),
                                        onTap: () {
                                          saveStringToSP(
                                              'searchFilter', 'title');
                                          update.changeSearchFilter('title');
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Search By',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15)),
                                  Icon(
                                    Icons.search,
                                    color: Color(0xffFED962),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _settingGroup("Other"),
                  Card(
                    elevation: 0.0,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//                      decoration: BoxDecoration(
//                          color: Colors.black87,
//                         ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat', fontSize: 15),
                                  ),
                                ],
                              ),
                              Switch(
                                activeColor: Color(0xffFED962),
                                value: darkMode,
                                onChanged: (val) {
                                  saveBoolToSharedPrefs('darkMode', val);
                                  setState(() {
                                    darkMode = val;
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
//                print('The connection hasn\'t finsihed yet');
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


