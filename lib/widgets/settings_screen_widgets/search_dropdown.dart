import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void saveStringToSP(String settingName, String val) async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(settingName, val);
    }

    Update update = Provider.of(context);
    ColorTheme colorTheme = Provider.of(context);
    return Theme(
      data: ThemeData(unselectedWidgetColor: colorTheme.headerText, accentColor: Colors.grey, dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Container( color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(0, 10, 30, 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: colorTheme.settingsIcon,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(' Search By',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: colorTheme.headerText)),
                ],
              ),
            ],
          ),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(49, 7, 17, 10),
            child: InkWell(
              onTap: () {
                saveStringToSP('searchFilter', 'author');
                update.changeSearchFilter('author');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Color(0xffFED962)),
                      Text(" Author",
                          style:
                              TextStyle(fontFamily: 'Montserrat', fontSize: 15,color: colorTheme.headerText))
                    ],
                  ),
                  update.searchFilter == "author"
                      ? Icon(Icons.done, color: Color(0xffFED962))
                      : Container()
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(49, 5, 17, 10),
            child: InkWell(
              onTap: () {
                saveStringToSP('searchFilter', 'title');
                update.changeSearchFilter('title');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.title, color: Color(0xffFED962)),
                      Text(" Title",
                          style:
                              TextStyle(fontFamily: 'Montserrat', fontSize: 15,color: colorTheme.headerText))
                    ],
                  ),
                  update.searchFilter == "title"
                      ? Icon(
                          Icons.done,
                          color: Color(0xffFED962),
                        )
                      : Container()
                ],
              ),
            ),
          ),
//        ListTile(
//          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//          title: Text("Author",
//              style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
//          trailing: update.searchFilter == "author" ? Icon(Icons.done) : null,
//          onTap: () {
//            saveStringToSP('searchFilter', 'author');
//            update.changeSearchFilter('author');
//          },
//        ),
//        ListTile(
//          trailing: update.searchFilter == "title" ? Icon(Icons.done) : null,
//          title: Text("Book Title",
//              style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
//          onTap: () {
//            saveStringToSP('searchFilter', 'title');
//            update.changeSearchFilter('title');
//          },
//        )
        ],
      ),
    );
  }
}
