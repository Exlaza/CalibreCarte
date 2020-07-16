import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String ENGLISH = 'en';
const String HINDI = 'hi';

const String LANGUAGECODE = 'languagecode';

Future<Locale> setLocale(String languageCode) async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGECODE, languageCode);

  return _locale(languageCode);

}

Locale _locale(String languageCode){
  Locale _temp;
  switch (languageCode) {
    case 'en':
      _temp = Locale(languageCode, 'US');
      break;
    case 'hi':
      _temp = Locale(languageCode, 'IN');
      break;
    default:
      _temp = Locale('en', 'US');
  }

  return _temp;
}

Future<Locale> getLocale() async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGECODE) ?? ENGLISH;

  return _locale(languageCode);

}