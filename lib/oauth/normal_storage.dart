import 'package:calibre_carte/oauth/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NormalStorage implements Storage {
  final SharedPreferences sp;
  static Future<NormalStorage> getInstance() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return NormalStorage(sp);

  }

  NormalStorage(this.sp);

  @override
  Future<String> read(String key) async{
    return sp.getString(key);
  }


  @override
  Future<bool> write(String key, String value) async{
    return await sp.setString(key, value);
  }

  @override
  Future<bool> containsKey(String key) async{
    return sp.containsKey(key);
  }

  @override
  Future<bool> delete(String key) async{
    return await sp.remove(key);
  }

}