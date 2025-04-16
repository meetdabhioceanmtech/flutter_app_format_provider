import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  void setValue({required bool value}) {
    _value = value;
    notifyListeners();
  }
}
