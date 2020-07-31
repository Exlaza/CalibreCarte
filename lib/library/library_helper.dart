
import 'package:calibre_carte/library/library.dart';

abstract class LibraryHelper {
  Future<List<Library>> searchLibraries();
  Future<bool> addLibrary(Library lib);
  Future<bool> switchLibrary(Library lib);
//  Future<String> downloadMetadata();
//  Future<bool> downloadBookCovers();
//  Future<bool> downloadBook();
}