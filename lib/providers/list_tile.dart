import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTileProvider extends ChangeNotifier {
  void refreshTile() {
    notifyListeners();
  }
}