import 'dart:io';

import 'package:calibre_carte/helpers/data_provider.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:directory_picker/directory_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DirectoryChange extends StatelessWidget {
  selectDirectory(context, ColorTheme colorTheme) async {
    Directory exd = await getExternalStorageDirectory();

    Directory newDirectory = await DirectoryPicker.pick(
        context: context,
        rootDirectory: exd,
        backgroundColor: colorTheme.alertBoxColor);

    if (newDirectory != null) {
      SharedPreferences _prefs= await SharedPreferences.getInstance();
      // Do something with the picked directory
//      Set the old directory so that I can search for all the downloaded files in the directory
      String oldDirectoryPath = await _prefs.getString("downloaded_directory");
//      Set the new directory in the shared preferences.
      _prefs.setString("downloaded_directory", newDirectory.path);
//      Get the books title and file extensions so that I can search for filenames
      List<Data> dataList = await DataProvider.getAllBooksData();
      List<Map<String, String>> dataFormatsFileNameMapTemp = List();

//      For all the filenames in here, I will searhc it one by one and then
//      rename it to the new one, which is supposedly equivalent as to moving it
      dataList.forEach((element) {
        String fNameWithExt = element.name + '.' + element.format.toLowerCase();
        String pathToSearch = oldDirectoryPath + '/$fNameWithExt';
        String pathToMove = newDirectory.path + '/$fNameWithExt';
//        The IF condition over her can probably be done in a better way
        if (File(pathToSearch).existsSync()) {
          File(pathToSearch).renameSync(pathToMove);
        }
      });
    } else {
      // User cancelled without picking any directory
    }
  }  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme=Provider.of(context);
    return GestureDetector(
      onTap: () => selectDirectory(context, colorTheme),
      child: Container(
        child: Container(
          padding: EdgeInsets.only(left: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.folder_open,
                  color: colorTheme.settingsIcon,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(" Select Download Directory",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        color: colorTheme.headerText))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
