import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DarkMode extends StatefulWidget {
  bool darkMode;
  DarkMode(this.darkMode);

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
    return  Card(
      elevation: 0.0,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30)),
      child: Container(
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
                    Icon(Icons.wb_sunny),
                    SizedBox(width: 10,),
                    Text(
                      ' Dark Mode',
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15),
                    ),
                  ],
                ),
                Switch(
                  activeColor: Color(0xffFED962),
                  value: widget.darkMode,
                  onChanged: (val) {
                    saveBoolToSharedPrefs('darkMode', val);
                    setState(() {
                      widget.darkMode = val;
                    });
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
