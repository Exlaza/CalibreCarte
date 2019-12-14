import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/connect_dropbox_screen.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/cloud_settings.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/dark_mode_toggle.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/search_dropdown.dart';
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
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[Icon(
                    settingIcon,
                    color: Color(0xffFED962),
                  ),
                      SizedBox(width: 10,),Text(settingName,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
                    ],)
                  , IconButton(icon: Icon(Icons.navigate_next),)
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
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _settingGroup("Cloud"),
                   CloudSettings(),
                    _settingGroup("Search"),
                   SearchDropdown(),
                    _settingGroup("Appearance"),
                   DarkMode(darkMode),_settingGroup("Help"),
                    Card(
                      elevation: 0.0,
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xffFED962),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("About",
                                      style:
                                      TextStyle(fontFamily: 'Montserrat', fontSize: 15))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Card(
                      elevation: 0.0,
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.help_outline,
                                    color: Color(0xffFED962),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Usage Instructions",
                                      style:
                                      TextStyle(fontFamily: 'Montserrat', fontSize: 15))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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


