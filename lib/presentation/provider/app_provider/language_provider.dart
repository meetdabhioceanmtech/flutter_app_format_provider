import 'package:flutter/material.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/presentation/globals.dart';

class LanguageProvider with ChangeNotifier {
  // final GetPreferredLanguage getPreferredLanguage;
  // final UpdateLanguage updateLanguage;

  Locale _locale = Locale(currentLangCode);
  Locale get locale => _locale;

  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;

  AppErrorType? _appErrorType;
  String? _errorMessage;

  AppErrorType? get appErrorType => _appErrorType;
  String? get errorMessage => _errorMessage;

  bool isMounted = true;

  LanguageProvider(
      //   {
      //   required this.getPreferredLanguage,
      //   required this.updateLanguage,
      // }
      );

  Future<void> toggleLanguage({required String shortCode}) async {
    // await updateLanguage(shortCode);
    await loadPreferredLanguage();
  }

  Future<void> loadPreferredLanguage() async {
    // final response = await getPreferredLanguage(NoParams());

    // if (!isMounted) return;

    // response.fold(
    //   (error) {
    //     _appErrorType = error.errorType;
    //     _errorMessage = error.message;
    //     notifyListeners();
    //   },
    //   (langCode) {
    //     _locale = Locale(langCode);
    //     notifyListeners();
    //   },
    // );
  }

  void changeLanguage(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
