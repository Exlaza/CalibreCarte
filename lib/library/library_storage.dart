import 'dart:convert';

import 'package:calibre_carte/library/library.dart';
import 'package:calibre_carte/oauth/normal_storage.dart';
import 'package:calibre_carte/oauth/storage.dart';


class LibraryCollectionStorage {
  String key;

  NormalStorage storage;

  static Future<LibraryCollectionStorage> getInstance(key) async {
    NormalStorage storage = await NormalStorage.getInstance();
    return LibraryCollectionStorage._(key, storage);
  }

  LibraryCollectionStorage._(this.key, this.storage);

  Future<bool> addLibrary(Library lib) async {
    await storage.write('current_library_provider_name', key);
    await storage.write('current_library_id', lib.id);

    Map<String, dynamic> libCollectionMap = jsonDecode(await storage.read(key));
    Map<String, dynamic> libMap = lib.toMap();

    if (libCollectionMap.containsKey(key)) {
      Map<String, dynamic> singleCollectionMap = libCollectionMap[key];
      singleCollectionMap[lib.id] = libMap;
    } else {
      libCollectionMap[key] = {lib.id: libMap};
    }

    return storage.write(key, jsonEncode(libCollectionMap));
  }


  Future<Library> getLibrary() async {
    Map<String, dynamic> libMap = jsonDecode(await storage.read(key));
    Library lib = Library.fromMap(libMap);
    return lib;
  }

  Future<List<Library>> getLibraryCollection() async {


  }
}


}