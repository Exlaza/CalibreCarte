
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalibreCarteLocalization {
  CalibreCarteLocalization(this.locale);

  final Locale locale;

  static CalibreCarteLocalization of(BuildContext context) {
    return Localizations.of<CalibreCarteLocalization>(context, CalibreCarteLocalization);
  }

  Map<String, String> _localisedValues;

  Future load() async{
    String jsonStringValues = await rootBundle.loadString('lib/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localisedValues = mappedJson.map((key, val) => MapEntry(key, val.toString()));

  }

  String getTranslatedValues(String key) {
    return _localisedValues[key];
  }


  static const LocalizationsDelegate<CalibreCarteLocalization> delegate = _CalibreCarteLocalizationDelegate();


}

class _CalibreCarteLocalizationDelegate extends LocalizationsDelegate<CalibreCarteLocalization>{
  const _CalibreCarteLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<CalibreCarteLocalization> load(Locale locale) async{
    CalibreCarteLocalization localization = CalibreCarteLocalization(locale);
    await localization.load();

    return localization;

  }

  @override
  bool shouldReload(_CalibreCarteLocalizationDelegate old) => false;



}