import 'package:flutter/material.dart';

class Update with ChangeNotifier {
  bool _tokenExists;
  bool _shouldUpdate = false;

  Update(this._tokenExists);

  void changeTokenState(bool tokenStateFlag) {
    _tokenExists = tokenStateFlag;
    notifyListeners();
  }

  void updateFlagState(bool updateFlag) {
    _shouldUpdate = updateFlag;
    notifyListeners();
  }

  bool get tokenExists {
    return _tokenExists;
  }
  bool get shouldDoUpdate {
    return _shouldUpdate;
  }
}
