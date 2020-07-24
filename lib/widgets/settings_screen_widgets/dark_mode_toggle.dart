import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DarkMode extends StatefulWidget {


  @override
  _DarkModeState createState() => _DarkModeState();
}

class _DarkModeState extends State<DarkMode> {
  void saveBoolToSharedPrefs(String settingName, bool val) async {
    SharedPreferences _prefs= await SharedPreferences.getInstance();
    _prefs.setBool(settingName, val);
  }

  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme=Provider.of(context);
    return  Card(color: Colors.transparent,
      elevation: 0.0,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30)),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(12, 1, 30, 1),
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
                    Icon(Icons.wb_sunny, color: colorTheme.headerText,),
                    SizedBox(width: 10,),
                    Text(
                      ' Dark Mode',
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: colorTheme.headerText),
                    ),
                  ],
                ),
                Switch(
                  activeColor: colorTheme.settingsIcon,
                  value: colorTheme.darkMode,
                  onChanged: (val) async{
//                    print("dark mode clicked");
                    saveBoolToSharedPrefs('darkMode', val);
//                    setState(() {
//                      widget.darkMode = val;
//                    });
                    val==true ? colorTheme.darkModeOn() : colorTheme.darkModeOff();
//                    print("dark mode done");
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
