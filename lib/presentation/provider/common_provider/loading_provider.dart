import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isMounted = true;

  void show() {
    if (!isMounted) return;
    _isLoading = true;
    notifyListeners();
  }

  void hide() {
    if (!isMounted) return;
    _isLoading = false;
    notifyListeners();
  }
}
