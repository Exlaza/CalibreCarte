import 'dart:convert';

import 'package:calibre_carte/oauth/access_token_response.dart';
import 'package:calibre_carte/oauth/secure_storage.dart';
import 'package:flutter/material.dart';

class TokenStorage {
  String key;

  SecureStorage storage;

  TokenStorage({this.key}) {
    storage = SecureStorage();
  }

  Future<void> addToken(AccessTokenResponse accessTokenResponse) async {
    Map<String, dynamic> tokenMap = accessTokenResponse.toMap();
    await storage.write(key, jsonEncode(tokenMap));
  }

  Future<AccessTokenResponse> getToken() async {
    AccessTokenResponse accessTokenResponse;

    if (await storage.containsKey(key)) {
      Map<String, dynamic> tokenMap = jsonDecode(await storage.read(key));
      accessTokenResponse = AccessTokenResponse.fromMap(tokenMap);
    }
  }

  Future<bool> deleteToken() async {
    await storage.delete(key);
    return true;
  }
}
