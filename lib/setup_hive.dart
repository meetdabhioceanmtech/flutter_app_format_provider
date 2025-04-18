import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/common/constants/languages.dart';
import 'package:flutter_project/common/constants/theme.dart';
import 'package:flutter_project/data/models/app_model/general_setting_model.dart';
import 'package:flutter_project/domain/entities/general_setting/general_setting_entity.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';
import 'package:flutter_project/domain/entities/user/user_entity.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class SetupHive {
  Future<void> setupHiveBoxes() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    Hive
      ..registerAdapter<AppLanguageEntity>(AppLanguageEntityAdapter())
      ..registerAdapter<GeneralSettingEntity>(GeneralSettingEntityAdapter())
      ..registerAdapter<Sector>(SectorAdapter())
      ..registerAdapter<UserLanguage>(UserLanguageAdapter())
      ..registerAdapter<UserEntity>(UserEntityAdapter())
      ..registerAdapter<StateData>(StateDataAdapter())
      ..registerAdapter<CityData>(CityDataAdapter());

    appBox = await Hive.openBox(HiveBoxConstants.JOB_SEARCH_BOX);
    appLanBox = await Hive.openBox(HiveBoxConstants.APP_LANGUAGE_BOX);
    currentLanBox = await Hive.openBox(HiveBoxConstants.CURRENT_LANGUAGE_BOX);
    userDataBox = await Hive.openBox(HiveBoxConstants.USER_DATA_BOX);
    generalSettingBox = await Hive.openBox(HiveBoxConstants.GENERAL_SETTING_BOX);
    appActivityAnaltics = await Hive.openBox(HiveBoxConstants.APP_ACTIVITY_ANALYTICS);

    isAppBox = true;
    isAppLanBox = true;
    isCurrentLanBox = true;
    isUserDataBox = true;
    isGeneralSettingBox = true;
    isAppActivityAnaltics = true;

    isFirst = appBox.get(HiveConstants.IS_FIRST_LOAD, defaultValue: true);
    currentLangCode = currentLanBox.get(HiveConstants.PREFERRED_LANGUAGE, defaultValue: 'en');
    userToken = userDataBox.get(HiveConstants.USER_TOKEN, defaultValue: null);
    userFcmToken = userDataBox.get(HiveConstants.USER_FCM_TOKEN, defaultValue: "notfound");
    deviceData = Map<String, String>.from(appBox.get(HiveConstants.DEVICE_DATA, defaultValue: {}));
    generalSettingEntity = generalSettingBox.get(HiveConstants.GENERAL_SETTING_DATA, defaultValue: null);
    userEntity = userDataBox.get(HiveConstants.USER_ENTITY_DATA, defaultValue: null);
    appNotification = appLanBox.get(HiveConstants.APP_NOTIFICATION, defaultValue: true);
    String tempTheme = generalSettingBox.get(HiveConstants.CURRENT_THEME, defaultValue: Themes.system.name);
    if (tempTheme == Themes.light.name) {
      currentTheme = Themes.light;
    } else if (tempTheme == Themes.dark.name) {
      currentTheme = Themes.dark;
    } else {
      currentTheme = Themes.system;
    }

    deviceData = await AppFunctions().initPlatformState();
    await _saveAssetsLangToDevice();
  }

  Future<void> loadLanguages() async {
    if (isFirst) {
      appBox.put(HiveConstants.IS_FIRST_LOAD, false);
      appBox.put(HiveConstants.SHARE_NUMBER, 0);
      appBox.put(HiveConstants.NAV_NUMBER, 0);

      languages = [AppLanguageEntity(id: 1, shortCode: 'en', name: 'English', isDefault: 1)];
      appLanBox.put(HiveConstants.APP_LANGUAGE_LIST, languages);
      currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, 'en');
    } else {
      languages = List<AppLanguageEntity>.from(
        appLanBox.get(
          HiveConstants.APP_LANGUAGE_LIST,
          defaultValue: <AppLanguageEntity>[
            AppLanguageEntity(id: 1, shortCode: 'en', name: 'English', isDefault: 1),
          ],
        ),
      );

      if (languages.isEmpty) {
        languages = [AppLanguageEntity(id: 1, shortCode: 'en', name: 'English', isDefault: 1)];
        appLanBox.put(HiveConstants.APP_LANGUAGE_LIST, languages);
      }

      final defaultLang = languages.firstWhere((lang) => lang.isDefault == 1, orElse: () => languages.first);
      currentLangCode = defaultLang.shortCode;
      currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, currentLangCode);
    }

    navigationCount = appBox.get(HiveConstants.NAV_NUMBER, defaultValue: 0);
  }

  Future<void> _saveAssetsLangToDevice() async {
    languageLocalPath =
        '${(await path_provider.getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}languages';

    ByteData byteData = await rootBundle.load("assets/languages/en.json");

    if (!await Directory(languageLocalPath).exists()) {
      await Directory(languageLocalPath).create();
    }
    File file = await File('$languageLocalPath/en.json').create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}
