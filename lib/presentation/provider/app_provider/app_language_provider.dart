import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';
import 'package:flutter_project/presentation/provider/common_provider/loading_provider.dart';
import 'package:hive/hive.dart';

class AppLanguageProvider extends ChangeNotifier {
  final Box appLanBox;
  final Box currentLanBox;

  bool isLoading = false;
  String? errorMessage;

  int selectIndex = 0;
  List<AppLanguageEntity> languageEntity = [];
  List<AppLanguageEntity> originalLanguageList = [];
  String selectedLanguage = 'en';

  AppLanguageProvider({
    required this.appLanBox,
    required this.currentLanBox,
  });

  Future<void> loadLanguagesFromAssets() async {
    isLoading = true;
    notifyListeners();

    try {
      // Load language list from assets
      final String response = await rootBundle.loadString('assets/languages/languages.json');
      final List<dynamic> jsonData = json.decode(response);

      // Convert JSON to language entities
      List<AppLanguageEntity> tempList = jsonData.map((item) => AppLanguageEntity.fromJson(item)).toList();

      if (tempList.isEmpty) {
        isLoading = false;
        errorMessage = "No languages found.";
        notifyListeners();
        return;
      }

      // Determine default language
      int defaultIndex = 0;
      String defaultCode = "en";

      // Check if we have previously saved language
      if (currentLanBox.containsKey(HiveConstants.PREFERRED_LANGUAGE)) {
        defaultCode = currentLanBox.get(HiveConstants.PREFERRED_LANGUAGE) ?? "en";
      }

      // Find the index of the default language
      final savedIndex = tempList.indexWhere((e) => e.shortCode == defaultCode);
      if (savedIndex != -1) {
        defaultIndex = savedIndex;
      }

      // Reset all languages to non-default
      tempList = tempList.map((e) => e.copyWith(isDefault: 0)).toList();

      // Set the selected language as default
      if (defaultIndex >= 0 && defaultIndex < tempList.length) {
        tempList[defaultIndex] = tempList[defaultIndex].copyWith(isDefault: 1);
      }

      // Save language list to local storage
      await currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, defaultCode);
      await appLanBox.put(HiveConstants.APP_LANGUAGE_LIST, tempList);

      // Update provider state
      languageEntity = tempList;
      originalLanguageList = tempList;
      selectIndex = defaultIndex;
      selectedLanguage = defaultCode;

      // Load language labels/translations
      await loadLanguageLabels(
        selectedIndex: defaultIndex,
        appLanguageEntity: tempList[defaultIndex],
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load languages: $e";
      notifyListeners();
    }
  }

  Future<void> loadLanguageLabels({
    required int selectedIndex,
    required AppLanguageEntity appLanguageEntity,
  }) async {
    try {
      // Load language labels/translations from assets
      final String response = await rootBundle.loadString('assets/languages/${appLanguageEntity.shortCode}.json');

      // Parse language data
      final Map<String, dynamic> languageData = json.decode(response);

      // Save language data to appropriate storage
      await currentLanBox.put(HiveConstants.LANGUAGE_LABELS, languageData);

      // Update provider state
      selectIndex = selectedIndex;
      selectedLanguage = appLanguageEntity.shortCode;

      // Reset all languages to non-default
      languageEntity = languageEntity.map((e) => e.copyWith(isDefault: 0)).toList();

      // Set selected language as default
      languageEntity[selectedIndex] = languageEntity[selectedIndex].copyWith(isDefault: 1);

      // Update original list
      originalLanguageList = List.from(languageEntity);

      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to load language labels for ${appLanguageEntity.shortCode}: $e";
      notifyListeners();
    }
  }

  Future<void> changeLanguage({required int index}) async {
    if (index == selectIndex) return;

    // loadingProvider.show();

    try {
      // Get current language list
      List<AppLanguageEntity> currentLanguages = List.from(languageEntity);

      // Reset all languages to non-default
      currentLanguages = currentLanguages.map((e) => e.copyWith(isDefault: 0)).toList();

      // Set selected language as default
      currentLanguages[index] = currentLanguages[index].copyWith(isDefault: 1);

      // Update local storage
      await currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, currentLanguages[index].shortCode);
      await appLanBox.put(HiveConstants.APP_LANGUAGE_LIST, currentLanguages);

      // Update provider state
      languageEntity = currentLanguages;
      originalLanguageList = currentLanguages;

      // Load translations for the selected language
      await loadLanguageLabels(
        selectedIndex: index,
        appLanguageEntity: currentLanguages[index],
      );

      // loadingProvider.hide();
    } catch (e) {
      // loadingProvider.hide();
      errorMessage = "Failed to change language: $e";
      notifyListeners();
    }
  }

  // Method to set language locally without immediately loading language labels
  Future<void> setLocallyLanguage({required int index}) async {
    if (index < 0 || index >= languageEntity.length) return;

    try {
      // Update select index
      selectIndex = index;

      // Reset all languages to non-default
      List<AppLanguageEntity> updatedList = languageEntity.map((e) => e.copyWith(isDefault: 0)).toList();

      // Set selected language as default
      updatedList[index] = updatedList[index].copyWith(isDefault: 1);
      selectedLanguage = updatedList[index].shortCode;

      // Update language lists
      languageEntity = updatedList;
      originalLanguageList = List.from(updatedList);

      // Save to storage
      await currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, selectedLanguage);
      await appLanBox.put(HiveConstants.APP_LANGUAGE_LIST, updatedList);

      // Notify listeners to rebuild UI
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to set language locally: $e";
      notifyListeners();
    }
  }

  void filterLanguageList(String searchString) {
    if (searchString.isEmpty) {
      languageEntity = List.from(originalLanguageList);
    } else {
      languageEntity = originalLanguageList
          .where((element) => element.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Helper method to get language label
  String getLabel(String key, {String defaultValue = ''}) {
    final Map<String, dynamic>? labels = currentLanBox.get(HiveConstants.LANGUAGE_LABELS);
    if (labels != null && labels.containsKey(key)) {
      return labels[key].toString();
    }
    return defaultValue.isEmpty ? key : defaultValue;
  }
}
