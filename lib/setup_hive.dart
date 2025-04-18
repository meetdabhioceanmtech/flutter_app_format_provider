import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/common/constants/theme.dart';
import 'package:flutter_project/data/models/app_model/general_setting_model.dart';
import 'package:flutter_project/domain/entities/general_setting/general_setting_entity.dart';
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

    //Language Management
    currentLangCode = currentLanBox.get(HiveConstants.PREFERRED_LANGUAGE, defaultValue: 'en');
    currentLanguagelabels = currentLanBox.get(HiveConstants.LANGUAGE_LABELS, defaultValue: null);
    if (currentLanguagelabels == null) {
      await _saveAssetsLangToDevice();
    }

    isFirst = appBox.get(HiveConstants.IS_FIRST_LOAD, defaultValue: true);
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
  }

  Future<void> loadLanguages() async {
    if (isFirst) {
      appBox.put(HiveConstants.IS_FIRST_LOAD, false);
      appBox.put(HiveConstants.SHARE_NUMBER, 0);
      appBox.put(HiveConstants.NAV_NUMBER, 0);
    }

    navigationCount = appBox.get(HiveConstants.NAV_NUMBER, defaultValue: 0);
  }

  Future<void> _saveAssetsLangToDevice() async {
    try {
      final String response = await rootBundle.loadString('assets/languages/en.json');

      final Map<String, dynamic> languageData = json.decode(response);
      await currentLanBox.put(HiveConstants.LANGUAGE_LABELS, languageData);
      currentLanguagelabels = languageData;
    } catch (e) {
      log('Error in _saveAssetsLangToDevice: $e');
    }
  }
}
