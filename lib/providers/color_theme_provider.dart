import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

const String TILE1_DARK = "#000b14";
const String TILE2_DARK = "#0e101c";
const String HEADER_TEXT_DARK = "#ffffff";
const String DESCRIPTION_BG_DARK = "";
const String SETTING_BG_DARK = "";
const String SETTINGS_TILE_DARK = "";
const String APP_BAR_DARK = "#002242";
const String APP_BAR_TITLE_DARK = "#eeeeee";
const String ALERTBOX_DARK="#000000";
const String ALERTBOX_LIGHT="#FFFFFF";
const String APPBAR_LIGHT="#002242";
class ColorTheme with ChangeNotifier{
  bool _darkMode;
  Color _tileColor1;
  Color _tileColor2;
  Color _descriptionBackground;
  Color _settingsBackground;
  Color _settingsTile;
  Color _headerText;
  Color _subHeaderText;
  Color _iconColor=Color(0xffFED962);
  Color _di;
  Color _appBarColor;
  Color _appBarTitleColor;
  Color _modalSheetColor=Colors.white.withOpacity(0.8);
  Color _alertBoxColor;

  Color get alertBoxColor => _alertBoxColor;

  Color get modalSheetColor => _modalSheetColor;

  ColorTheme(this._darkMode){
    if(_darkMode==true){
      _alertBoxColor=_colorFromHex(ALERTBOX_DARK);
//      _tileColor1=Colors.black87;
      _appBarColor=_colorFromHex(APP_BAR_DARK);
      _appBarTitleColor=_colorFromHex(APP_BAR_TITLE_DARK);
      _tileColor1=_colorFromHex(TILE1_DARK);
//      _tileColor2=Colors.black;
      _tileColor2=_colorFromHex(TILE2_DARK);

      _descriptionBackground=Colors.black;
      _settingsBackground=Colors.black54;
//      _settingsBackground=Color(0xff303841);
//      _settingsBackground=Color(0xff132436);
//      _headerText=Colors.white;
//    _headerText=Color(0xfff6c90e);
      _headerText=_colorFromHex(HEADER_TEXT_DARK);
//    _subHeaderText=Color(0xffeeeeee);
      _subHeaderText=Color(0xffFED962);
      _settingsTile=Colors.black;
      _di = Color(0xffFED962);

    }
    else{
      _tileColor1= Colors.white;
      _tileColor2=Colors.white70;
      _descriptionBackground=Colors.white;
      _settingsBackground=Colors.white;
      _headerText=Color(0xff002242);
      _subHeaderText=Color(0xffb6b2df);
      _settingsTile=Colors.white;
      _di = Color(0xffFFE06F);
      _alertBoxColor=_colorFromHex(ALERTBOX_LIGHT);
      _appBarColor=_colorFromHex(APPBAR_LIGHT);
    }
  }


  Color get iconColor => _iconColor;

  bool get darkMode => _darkMode;

  void darkModeOn(){
    _alertBoxColor=_colorFromHex(ALERTBOX_DARK);
    _appBarColor=_colorFromHex(APP_BAR_DARK);
//      _tileColor1=Colors.black87;
    _tileColor1=_colorFromHex(TILE1_DARK);
    _appBarTitleColor=_colorFromHex(APP_BAR_TITLE_DARK);
//      _tileColor2=Colors.black;
    _tileColor2=_colorFromHex(TILE2_DARK);
    _descriptionBackground=Colors.black;
//      _settingsBackground=Colors.black54;
    _settingsBackground=Color(0xff303841);
//      _headerText=Colors.white;
//    _headerText=Color(0xfff6c90e);
    _headerText=_colorFromHex(HEADER_TEXT_DARK);
//    _subHeaderText=Color(0xffeeeeee);
    _subHeaderText=Color(0xff6b778d);
    _settingsTile=Colors.grey;
    _di = Color(0xffff6768);
    _darkMode=true;
//    _tileColor1=Colors.black87;
//    _tileColor2=Colors.black;
//    _descriptionBackground=Colors.black;
//    _settingsBackground=Colors.black54;
//    _headerText=Colors.white;
//    _subHeaderText=Color(0xffFED962);
//    _settingsTile=Colors.grey;
    notifyListeners();
  }

  void darkModeOff(){
    _alertBoxColor=_colorFromHex(ALERTBOX_LIGHT);
    _darkMode=false;
    _tileColor1= Colors.white;
    _tileColor2=Colors.white70;
    _descriptionBackground=Colors.white;
    _settingsBackground=Colors.white;
    _headerText=Color(0xff002242);
    _subHeaderText=Color(0xffb6b2df);
    _settingsTile=Colors.white;
    _di = Color(0xffFFE06F);
    _appBarColor=_colorFromHex(APPBAR_LIGHT);
    notifyListeners();
  }

  Color get settingsTile => _settingsTile;

  Color get tileColor1 => _tileColor1;

  Color get tileColor2 => _tileColor2;

  Color get descriptionBackground => _descriptionBackground;

  Color get settingsBackground => _settingsBackground;

  Color get headerText => _headerText;

  Color get subHeaderText => _subHeaderText;

  Color get di => _di;

  Color get appBarColor => _appBarColor;

  Color get appBarTitleColor => _appBarTitleColor;

}