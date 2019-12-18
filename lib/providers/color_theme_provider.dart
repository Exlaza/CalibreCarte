import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorTheme with ChangeNotifier{
  bool _darkMode;
  Color _tileColor1;
  Color _tileColor2;
  Color _descriptionBackground;
  Color _settingsBackground;
  Color _headerText;
  Color _subHeaderText;
  ColorTheme(this._darkMode){
    if(_darkMode==true){
      _tileColor1=Colors.black87;
      _tileColor2=Colors.black;
      _descriptionBackground=Colors.black;
      _settingsBackground=Colors.black54;
      _headerText=Colors.white;
      _subHeaderText=Color(0xffFED962);
    }
    else{
      _tileColor1= Colors.white;
      _tileColor2=Colors.white70;
      _descriptionBackground=Colors.white;
      _settingsBackground=Colors.white;
      _headerText=Color(0xff002242);
      _subHeaderText=Color(0xffb6b2df);
    }
  }


  bool get darkMode => _darkMode;

  void darkModeOn(){
    _darkMode=true;
    _tileColor1=Colors.black87;
    _tileColor2=Colors.black;
    _descriptionBackground=Colors.black;
    _settingsBackground=Colors.black54;
    _headerText=Colors.white;
    _subHeaderText=Color(0xffFED962);
    notifyListeners();
  }

  void darkModeOff(){
    _darkMode=false;
    _tileColor1= Colors.white;
    _tileColor2=Colors.white70;
    _descriptionBackground=Colors.white;
    _settingsBackground=Colors.white;
    _headerText=Color(0xff002242);
    _subHeaderText=Color(0xffb6b2df);
    notifyListeners();
  }

  Color get tileColor1 => _tileColor1;

  Color get tileColor2 => _tileColor2;

  Color get descriptionBackground => _descriptionBackground;

  Color get settingsBackground => _settingsBackground;

  Color get headerText => _headerText;

  Color get subHeaderText => _subHeaderText;

}