import 'package:calibre_carte/oauth/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage extends Storage {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  SecureStorage();

  @override
  Future<String> read(String key) async{
    return await storage.read(key: key);
  }


  @override
  Future<void> write(String key, String value) async{
    return await storage.write(key: key, value: value);
  }

  @override
  Future<bool> containsKey(String key) async{
    return (await storage.read(key: key)) != null;
  }

  @override
  Future<void> delete(String key) async{
    // TODO: implement delete
    return await storage.delete(key: key);
  }

}