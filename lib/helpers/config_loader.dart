import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:calibre_carte/helpers/configuration.dart';
import 'package:flutter/services.dart' show rootBundle;

class ConfigLoader {
  final String secretPath;

  ConfigLoader({this.secretPath});

  Future<Configuration> load() {
    return rootBundle.loadStructuredData<Configuration>(this.secretPath,
        (jsonStr) async {
      final secret = Configuration.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
