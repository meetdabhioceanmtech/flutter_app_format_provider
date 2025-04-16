import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/theme.dart';
import 'package:flutter_project/presentation/globals.dart';

class ThemeProvider extends ChangeNotifier {
  Themes _currentTheme = Themes.system;

  Themes get currentThemes => _currentTheme;

  ThemeProvider() {
    loadPreferredTheme();
  }

  Future<void> toggleTheme(Themes theme) async {
    var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    if (theme == Themes.system) {
      appConstants.loadColor(isLightMode);
    } else {
      appConstants.loadColor(theme == Themes.light);
    }

    _currentTheme = theme;
    currentTheme = theme;
    notifyListeners();
  }

  void loadPreferredTheme() {
    // load from sharedPrefs if needed
    // Example:
    // _currentTheme = Themes.light;
    // notifyListeners();
  }
}
