import 'dart:async';

import 'package:hive/hive.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';

abstract class LanguageLocalDataSource {
  Future<void> updateLanguage(String languageCode);
  Future<String> getPreferredLanguage();
}

class LanguageLocalDataSourceImpl extends LanguageLocalDataSource {
  @override
  Future<String> getPreferredLanguage() async {
    final languageBox = await Hive.openBox(HiveBoxConstants.CURRENT_LANG_BOX);
    return languageBox.get(HiveConstants.PREFERRED_LANGUAGE, defaultValue: 'en');
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    final languageBox = await Hive.openBox(HiveBoxConstants.CURRENT_LANG_BOX);
    unawaited(languageBox.put(HiveConstants.PREFERRED_LANGUAGE, languageCode));
  }
}
