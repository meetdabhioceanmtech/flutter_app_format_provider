import 'package:flutter/material.dart';

class BottomNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  final List<int> _loadedPages = [0];

  int get currentIndex => _currentIndex;
  List<int> get loadedPages => _loadedPages;

  void changeIndex(int index) {
    if (!_loadedPages.contains(index)) {
      _loadedPages.add(index);
    }
    _currentIndex = index;
    notifyListeners();
  }
}
