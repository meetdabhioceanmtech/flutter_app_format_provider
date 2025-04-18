import 'package:flutter/material.dart';
import 'package:flutter_project/presentation/globals.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale(currentLangCode);
  Locale get locale => _locale;

  bool isMounted = true;

  LanguageProvider() {
    // Listen for changes to currentLangCode
    _locale = Locale(currentLangCode);
  }

  void updateLocale(Locale newLocale) {
    if (_locale.languageCode != newLocale.languageCode) {
      _locale = newLocale;
      // Force a rebuild of the entire app
      notifyListeners();
    }
  }

  // Add a method to refresh the locale from currentLangCode
  void refreshLocale() {
    _locale = Locale(currentLangCode);
    notifyListeners();
  }
}
