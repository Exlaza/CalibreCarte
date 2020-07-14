import 'dart:io';

import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/about_us.dart';
import 'package:calibre_carte/screens/instructions_screen.dart';
import 'package:calibre_carte/screens/license.dart';
import 'package:calibre_carte/screens/privacy_policy.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/cloud_settings.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/dark_mode_toggle.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/directorychange_button.dart';
import 'package:calibre_carte/widgets/settings_screen_widgets/search_dropdown.dart';
import 'package:directory_picker/directory_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

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

  Widget _settingGroup(groupName) {
    return Container(
        padding: EdgeInsets.only(left: 16),
        child: Text(
          groupName,
          style: TextStyle(
              fontFamily: 'Montserrat', color: Colors.grey, fontSize: 20),
        ));
  }



  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    ColorTheme colorTheme = Provider.of(context);
    Widget loadingWidget = Center(
      child: CircularProgressIndicator(),
    );
    return Scaffold(
      backgroundColor: colorTheme.settingsBackground,
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
                    SizedBox(
                      height: 20,
                    ),
                    _settingGroup("Cloud"),
                    CloudSettings(),
                    _settingGroup("Search"),
                    SearchDropdown(),
                    _settingGroup("Appearance"),
                    DarkMode(),
                    _settingGroup("Download Directory"),
                    Theme(data:ThemeData(primaryColor:  Color(0xffFED962)),
                      child:DirectoryChange()
                    ),
                    _settingGroup("Help"),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AboutUs();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16, bottom: 0, top:10),
                        child: Container(
                          padding: EdgeInsets.only(top: 4),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.help_outline,
                                color: Color(0xffFED962),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(" About Calibre Carte",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: colorTheme.headerText))
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PrivacyPolicy();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16, bottom: 0,top: 10),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.help_outline,
                                color: Color(0xffFED962),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(" Privacy Policy",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: colorTheme.headerText))
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Instructions();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16, bottom: 0, top:10),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.help_outline,
                                color: Color(0xffFED962),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(" Usage Instructions",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: colorTheme.headerText))
                            ],
                          ),
                        ),
                      ),
                    ),InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return License();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16, top: 10),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.info_outline,
                                color: Color(0xffFED962),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(" License",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: colorTheme.headerText))
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
