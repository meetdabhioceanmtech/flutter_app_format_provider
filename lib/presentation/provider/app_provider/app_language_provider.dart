import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/common/constants/languages.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/custom_snackbar.dart';

class AppLanguageProvider extends ChangeNotifier {
  bool isLoading = false;

  int selectIndex = 0;
  List<AppLanguageEntity> languageEntity = [];

  AppLanguageProvider();

  Future<void> loadLanguagesFromAssets() async {
    languageEntity = languagesList;
    int index = languagesList.indexWhere((element) => element.shortCode == currentLangCode);
    if (index != -1) {
      selectIndex = index;
    }
    notifyListeners();
  }

  Future<void> setLocallyLanguage() async {
    loader(true);
    notifyListeners();

    AppLanguageEntity appLanguageEntity = languagesList[selectIndex];
    try {
      String shortCode = appLanguageEntity.shortCode;
      // Load language labels/translations from assets
      final String response = await rootBundle.loadString('assets/languages/$shortCode.json');

      // Parse language data
      final Map<String, dynamic> languageData = json.decode(response);

      // Save language data to appropriate storage
      await currentLanBox.put(HiveConstants.LANGUAGE_LABELS, languageData);
      await currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, shortCode);

      // Save language file to local storage
      final String langFilePath = '$languageLocalPath${Platform.pathSeparator}$shortCode.json';
      final File langFile = File(langFilePath);
      await langFile.writeAsString(response);

      currentLanguagelabels = languageData;
      currentLangCode = shortCode;

      // Refresh the LanguageProvider
      languageProvider.refreshLocale();

      Future.delayed(
        const Duration(seconds: 1),
        () {
          loader(false);
          notifyListeners();
        },
      );
      notifyListeners();
    } catch (e) {
      loader(false);
      CustomSnackbar.show(
        message: 'Failed to load language labels for ${appLanguageEntity.shortCode}: $e',
        snackbarType: SnackbarType.ERROR,
      );
      notifyListeners();
    }
  }

  void loader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void filterLanguageList(String searchString) {
    if (searchString.isEmpty) {
      languageEntity = List.from(languagesList);
    } else {
      languageEntity =
          languagesList.where((element) => element.name.toLowerCase().contains(searchString.toLowerCase())).toList();
    }
    notifyListeners();
  }

  void selectLanguage(int index) {
    selectIndex = index;
    notifyListeners();
  }
}
