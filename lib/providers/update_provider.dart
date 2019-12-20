import 'package:flutter/material.dart';

class Update with ChangeNotifier {
  bool _tokenExists;
  bool _shouldUpdate = false;
  String _searchFilter;

  Update(this._tokenExists, this._searchFilter) {
//    print("search filter $_searchFilter");
//    print("token existance $_tokenExists");
  }

  void changeTokenState(bool tokenStateFlag) {
    _tokenExists = tokenStateFlag;
    notifyListeners();
  }

  void updateFlagState(bool updateFlag) {
    _shouldUpdate = updateFlag;
    notifyListeners();
  }

  void changeSearchFilter(String filter) {
    _searchFilter = filter;
    notifyListeners();
  }

  void shouldDoUpdateFalse() {
    _shouldUpdate = false;
  }

  bool get tokenExists {
    return _tokenExists;
  }

  bool get shouldDoUpdate {
    return _shouldUpdate;
  }

  String get searchFilter {
//    print("returning $_searchFilter");
    return _searchFilter;
  }
}
