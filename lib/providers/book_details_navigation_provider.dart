import 'package:flutter/material.dart';

class BookDetailsNavigation with ChangeNotifier {
  int currentIndex;

  void incrementIndex() {
    currentIndex = currentIndex + 1;
    notifyListeners();
  }

  void decrementIndex() {
    currentIndex = currentIndex + 1;
    notifyListeners();
  }

}
