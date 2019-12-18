import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/connect_dropbox_screen.dart';
import 'package:calibre_carte/widgets/Settings%20Screen%20Widgets/dropbox_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CloudSettings extends StatefulWidget {
  @override
  _CloudSettingsState createState() => _CloudSettingsState();
}

class _CloudSettingsState extends State<CloudSettings> {
  bool isExpanded = false;

  Widget _settingsCard(
      ColorTheme colorTheme, settingName, settingIcon, Function onClicked) {
    return Theme(
      data: ThemeData(
          unselectedWidgetColor: colorTheme.headerText, accentColor: Colors.grey,dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Container(
          child: InkWell(
            onTap: onClicked,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        settingIcon,
                        color: Color(0xffFED962),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(settingName,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              color: colorTheme.headerText))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        children: <Widget>[DropboxDropdown()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    ColorTheme colorTheme = Provider.of(context);

    return _settingsCard(colorTheme, ' Dropbox',
        update.tokenExists ? Icons.cloud_done : Icons.cloud_off, () {
//                            print('Tap is not working');
    });
  }
}
