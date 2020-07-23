import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

const String TILE1_DARK = "#242633";
const String TILE2_DARK = "#303346";
const String HEADER_TEXT_DARK = "#eeeeee";
const String DESCRIPTION_BG_DARK = "";
const String SETTING_BG_DARK = "";
const String SETTINGS_TILE_DARK = "";
const String APP_BAR_DARK = "#FED428";
const String APP_BAR_TITLE_DARK = "#242725";
const String ALERTBOX_DARK="#EEEEEE";
const String ALERTBOX_LIGHT="#FFFFFF";
const String APPBAR_LIGHT="#002242";
const String TILE_UNDERLINE_LIGHT = "#00c6ff";
const String TILE_UNDERLINE_DARK = "#E35E58";
const String DESCRIPTION_ICON_COLOR_DARK = "#242633";
const String DESCRIPTION_ICON_ALT_COLOR_DARK = "#303346";
const String DESCRIPTION_ICON_COLOR_LIGHT = "#FED962";
const String DESCRIPTION_ICON_ALT_COLOR_LIGHT = "#FFE06F";
const String DESCRIPTION_ICON_ENABLED_LIGHT = "#FFFFFF";
const String DESCRIPTION_ICON_ENABLED_DARK = "#";
const String DESCRIPTION_ICON_DISABLED_LIGHT = "#";
const String DESCRIPTION_ICON_DISABLED_DARK = "#2CCA90";

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
  Color _tileUnderlineColor;
  Color _descriptionIconAltColor;
  Color _descriptionIconColor;

  Color get alertBoxColor => _alertBoxColor;
  Color get descriptionIconColor => _descriptionIconColor;
  Color get descriptionIconAltColor => _descriptionIconAltColor;

  Color get modalSheetColor => _modalSheetColor;
  Color get tileUnderlineColor => _tileUnderlineColor;

  ColorTheme(this._darkMode){
    if(_darkMode==true){
      _alertBoxColor=_colorFromHex(ALERTBOX_DARK);
//      _tileColor1=Colors.black87;
      _appBarColor=_colorFromHex(APP_BAR_DARK);
      _appBarTitleColor=_colorFromHex(APP_BAR_TITLE_DARK);
      _tileColor1=_colorFromHex(TILE1_DARK);
//      _tileColor2=Colors.black;
      _tileColor2=_colorFromHex(TILE2_DARK);
      _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_DARK);
      _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_DARK);
      _descriptionBackground=Colors.black;
//      _settingsBackground=Colors.black54;
//      _settingsBackground=Color(0xff303841);
      _settingsBackground=Color(0xff132436);
//      _headerText=Colors.white;
//    _headerText=Color(0xfff6c90e);
      _headerText=_colorFromHex(HEADER_TEXT_DARK);
//    _subHeaderText=Color(0xffeeeeee);
      _subHeaderText=Color(0xff6b778d);
      _settingsTile=Colors.grey;
      _di = Color(0xffff6768);
      _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_DARK);

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
      _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_LIGHT);
      _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_LIGHT);
      _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_LIGHT);


    }
  }


  Color get iconColor => _iconColor;

  bool get darkMode => _darkMode;

  void darkModeOn(){
    _alertBoxColor=_colorFromHex(ALERTBOX_DARK);
    _appBarColor=_colorFromHex(APP_BAR_DARK);
    _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_DARK);
    _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_DARK);
    _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_DARK);


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
    _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_LIGHT);
    _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_LIGHT);
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
    _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_LIGHT);
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