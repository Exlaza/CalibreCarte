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
    return ExpansionTile(
      title: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Color(0xffFED962),
                ),
                Text('Search By',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
      children: <Widget>[
        ListTile(
          title: Text("Author",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
          trailing: update.searchFilter == "author" ? Icon(Icons.done) : null,
          onTap: () {
            saveStringToSP('searchFilter', 'author');
            update.changeSearchFilter('author');
          },
        ),
        ListTile(
          trailing: update.searchFilter == "title" ? Icon(Icons.done) : null,
          title: Text("Book Title",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
          onTap: () {
            saveStringToSP('searchFilter', 'title');
            update.changeSearchFilter('title');
          },
        )
      ],
    );
  }
}
