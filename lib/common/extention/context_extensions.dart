import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void closeKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
