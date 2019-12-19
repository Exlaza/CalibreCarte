import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:calibre_carte/helpers/client_id.dart';
import 'package:flutter/services.dart' show rootBundle;
class IdLoader {
  final String secretPath;

  IdLoader({this.secretPath});
  Future<ClientId> load() {
    return rootBundle.loadStructuredData<ClientId>(this.secretPath,
            (jsonStr) async {
          final secret = ClientId.fromJson(json.decode(jsonStr));
          return secret;
        });
  }
}