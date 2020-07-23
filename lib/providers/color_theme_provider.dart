import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

const String TILE1_DARK = "#000000";
const String TILE2_DARK = "#121212";
const String HEADER_TEXT_DARK = "#eeeeee";
const String DESCRIPTION_BG_DARK = "";
const String SETTING_BG_DARK = "";
const String SETTINGS_TILE_DARK = "";
const String APP_BAR_DARK = "#242633";
const String APP_BAR_TITLE_DARK = "#eeeeee";
const String ALERTBOX_DARK = "#000000";
const String ALERTBOX_LIGHT = "#FFFFFF";
const String APPBAR_LIGHT = "#002242";
const String TILE_UNDERLINE_LIGHT = "#00c6ff";
const String TILE_UNDERLINE_DARK = "#E35E58";
const String DESCRIPTION_ICON_COLOR_DARK = "#242633";
const String DESCRIPTION_ICON_ALT_COLOR_DARK = "#303346";
const String DESCRIPTION_ICON_COLOR_LIGHT = "#FED962";
const String DESCRIPTION_ICON_ALT_COLOR_LIGHT = "#FFE06F";
const String DESCRIPTION_ICON_ENABLED_LIGHT = "#FFFFFF";
const String DESCRIPTION_ICON_ENABLED_DARK = "#2CCA90";
const String DESCRIPTION_ICON_DISABLED_LIGHT = "#";
const String DESCRIPTION_ICON_DISABLED_DARK = "#2CCA90";
const String DESCRIPTION_ARROW_DARK="#FFFFFF";
const String DESCRIPTION_ARROW_LIGHT="#FED962";
const String DESCRIPTION_ARROW_BGD_LIGHT="#002242";
const String DESCRIPTION_ARROW_BGD_DARK="#000000";
const String SETTINGS_ICON_LIGHT="#FED962";
const String SETTINGS_ICON_DARK="#ff6768";
class ColorTheme with ChangeNotifier {
  bool _darkMode;
  Color _tileColor1;
  Color _tileColor2;
  Color _descriptionBackground;
  Color _settingsBackground;
  Color _settingsTile;
  Color _headerText;
  Color _subHeaderText;
  Color _iconColor = Color(0xffFED962);
  Color _di;
  Color _appBarColor;
  Color _appBarTitleColor;
  Color _modalSheetColor = Colors.white.withOpacity(0.8);
  Color _alertBoxColor;
  Color _tileUnderlineColor;
  Color _descriptionIconAltColor;
  Color _descriptionIconColor;
  Color _descriptionIconEnabled;
  Color _descriptionArrow;
  Color _descriptionArrowBackground;
  Color _settingsIcon;

  Color get settingsIcon => _settingsIcon;

  Color get descriptionArrowBackground => _descriptionArrowBackground;

  Color get descriptionArrow => _descriptionArrow;

  Color get alertBoxColor => _alertBoxColor;

  Color get descriptionIconColor => _descriptionIconColor;

  Color get descriptionIconAltColor => _descriptionIconAltColor;

  Color get descriptionIconEnabledColor => _descriptionIconEnabled;

  Color get modalSheetColor => _modalSheetColor;

  Color get tileUnderlineColor => _tileUnderlineColor;

  ColorTheme(this._darkMode) {
    if (_darkMode == true) {
      _settingsIcon=_colorFromHex(SETTINGS_ICON_DARK);
      _descriptionArrowBackground=_colorFromHex(DESCRIPTION_ARROW_BGD_DARK);
      _alertBoxColor = _colorFromHex(ALERTBOX_DARK);
      _appBarColor = _colorFromHex(APP_BAR_DARK);
      _appBarTitleColor = _colorFromHex(APP_BAR_TITLE_DARK);
      _tileColor1 = _colorFromHex(TILE1_DARK);
      _tileColor2 = _colorFromHex(TILE2_DARK);
      _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_DARK);
      _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_DARK);
      _descriptionBackground = Color(0xff232324);
      _descriptionArrow=_colorFromHex(DESCRIPTION_ARROW_DARK);
      _settingsBackground = Color(0xff000000);

      _headerText = _colorFromHex(HEADER_TEXT_DARK);
      _subHeaderText = Color(0xff6b778d);
      _settingsTile = Colors.black;
      _di = Color(0xffff6768);
      _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_DARK);
      _descriptionIconEnabled = _colorFromHex(DESCRIPTION_ICON_ENABLED_DARK);
    } else {
      _settingsIcon=_colorFromHex(SETTINGS_ICON_LIGHT);

      _descriptionArrowBackground=_colorFromHex(DESCRIPTION_ARROW_BGD_LIGHT);

      _tileColor1 = Colors.white;
      _tileColor2 = Colors.white70;
      _descriptionBackground = Colors.white;
      _settingsBackground = Colors.white;
      _headerText = Color(0xff002242);
      _subHeaderText = Color(0xffb6b2df);
      _settingsTile = Colors.white;
      _di = Color(0xffFFE06F);
      _alertBoxColor = _colorFromHex(ALERTBOX_LIGHT);
      _appBarColor = _colorFromHex(APPBAR_LIGHT);
      _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_LIGHT);
      _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_LIGHT);
      _descriptionIconAltColor =
          _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_LIGHT);
      _descriptionIconEnabled = _colorFromHex(DESCRIPTION_ICON_ENABLED_LIGHT);
      _descriptionArrow=_colorFromHex(DESCRIPTION_ARROW_LIGHT);

    }
  }

  Color get iconColor => _iconColor;

  bool get darkMode => _darkMode;

  void darkModeOn() {
    _settingsIcon=_colorFromHex(SETTINGS_ICON_DARK);

    _descriptionArrowBackground=_colorFromHex(DESCRIPTION_ARROW_BGD_DARK);
    _descriptionArrow=_colorFromHex(DESCRIPTION_ARROW_DARK);
    _alertBoxColor = _colorFromHex(ALERTBOX_DARK);
    _appBarColor = _colorFromHex(APP_BAR_DARK);
    _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_DARK);
    _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_DARK);
    _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_DARK);
    _descriptionIconEnabled = _colorFromHex(DESCRIPTION_ICON_ENABLED_DARK);

//      _tileColor1=Colors.black87;
    _tileColor1 = _colorFromHex(TILE1_DARK);
    _appBarTitleColor = _colorFromHex(APP_BAR_TITLE_DARK);
    _tileColor2 = _colorFromHex(TILE2_DARK);
    _descriptionBackground = Colors.black;
    _settingsBackground = Color(0xff242633);
    _headerText = _colorFromHex(HEADER_TEXT_DARK);
    _subHeaderText = Color(0xff6b778d);
    _settingsTile = Colors.black;
    _di = Color(0xffff6768);
    _darkMode = true;
    notifyListeners();
  }

  void darkModeOff() {
    _settingsIcon=_colorFromHex(SETTINGS_ICON_LIGHT);

    _descriptionArrowBackground=_colorFromHex(DESCRIPTION_ARROW_BGD_LIGHT);

    _alertBoxColor = _colorFromHex(ALERTBOX_LIGHT);
    _descriptionIconColor = _colorFromHex(DESCRIPTION_ICON_COLOR_LIGHT);
    _descriptionIconAltColor = _colorFromHex(DESCRIPTION_ICON_ALT_COLOR_LIGHT);
    _descriptionIconEnabled = _colorFromHex(DESCRIPTION_ICON_ENABLED_LIGHT);
    _darkMode = false;
    _tileColor1 = Colors.white;
    _tileColor2 = Colors.white70;
    _descriptionBackground = Colors.white;
    _settingsBackground = Colors.white;
    _headerText = Color(0xff002242);
    _subHeaderText = Color(0xffb6b2df);
    _settingsTile = Colors.white;
    _di = Color(0xffFFE06F);
    _appBarColor = _colorFromHex(APPBAR_LIGHT);
    _tileUnderlineColor = _colorFromHex(TILE_UNDERLINE_LIGHT);
    _descriptionArrow=_colorFromHex(DESCRIPTION_ARROW_LIGHT);

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
