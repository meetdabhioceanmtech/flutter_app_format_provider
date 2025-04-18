import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/common/constants/languages.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:path_provider/path_provider.dart';

class AppLocalizations {
  late final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(context) => Localizations.of<AppLocalizations>(context, AppLocalizations);

  late Map<String, String> _localizedStrings;
  late Map<String, String> _fallbackLocalizedStrings;

  Future<bool> load(bool status) async {
    try {
      String langFile =
          '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}languages${Platform.pathSeparator}${locale.languageCode}.json';

      if (await File(langFile).exists()) {
        // Load the language file from local storage
        String fileData = await File(langFile).readAsString();
        final Map<String, dynamic> jsonMap = json.decode(fileData);
        _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));

        // Load English as fallback
        final jsonString = await rootBundle.loadString('assets/languages/en.json');
        final Map<String, dynamic> fallBackJsonMap = json.decode(jsonString);
        _fallbackLocalizedStrings = fallBackJsonMap.map((key, value) => MapEntry(key, value.toString()));

        return true;
      } else {
        // If local file doesn't exist, try to load from assets
        try {
          final jsonString = await rootBundle.loadString('assets/languages/${locale.languageCode}.json');
          final Map<String, dynamic> jsonMap = json.decode(jsonString);
          _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));

          // Load English as fallback
          final fallbackJsonString = await rootBundle.loadString('assets/languages/en.json');
          final Map<String, dynamic> fallBackJsonMap = json.decode(fallbackJsonString);
          _fallbackLocalizedStrings = fallBackJsonMap.map((key, value) => MapEntry(key, value.toString()));

          return true;
        } catch (e) {
          // If asset file doesn't exist, fall back to English
          final jsonString = await rootBundle.loadString('assets/languages/en.json');
          final Map<String, dynamic> jsonMap = json.decode(jsonString);
          _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
          _fallbackLocalizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error loading language file: ${e.toString()}');
      // Load English as fallback in case of any error
      try {
        final jsonString = await rootBundle.loadString('assets/languages/en.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
        _fallbackLocalizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
        return true;
      } catch (e) {
        debugPrint('Error loading fallback language file: ${e.toString()}');
        return false;
      }
    }
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }

  String? defaultTranslate(String key) {
    return _fallbackLocalizedStrings[key];
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    // print("Locale" + locale.languageCode.toString());
    // print("Locale" + languages.map((e) => e.shortCode).toList().contains(locale.languageCode).toString());
    return languagesList.map((e) => e.shortCode).toList().contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    String langFile =
        '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}languages${Platform.pathSeparator}${locale.languageCode}.json';

    if (await File(langFile).exists()) {
      AppLocalizations localizations = AppLocalizations(locale);
      await localizations.load(true);
      return localizations;
    } else {
      AppLocalizations localizations = AppLocalizations(const Locale('en'));

      await localizations.load(false);

      List<AppLanguageEntity> tempList = <AppLanguageEntity>[];
      for (var element in languagesList) {
        tempList.add(element.copyWith(isDefault: 0));
      }
      tempList[0] = tempList[0].copyWith(isDefault: 1);
      languagesList = tempList;
      currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, 'en');
      return localizations;
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
