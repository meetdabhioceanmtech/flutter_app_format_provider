// ignore_for_file: empty_catches

import 'dart:developer';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/common/constants/route_constants.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

void commonPrint(Object? object) {
  debugPrint(object.toString());
}

class AppFunctions {
  bool isUserLoggedIn() {
    bool isUserLoggedIn = false;
    if (userEntity != null && userToken != null && userToken!.isNotEmpty) {
      return true;
    }
    return isUserLoggedIn;
  }

  String? getUserToken() {
    // String? token;
    // if (userLoginData != null) {
    //   return userLoginData!.token;
    // }
    String? accessToken = userDataBox.get(HiveConstants.USER_TOKEN, defaultValue: null);
    userToken = accessToken;

    if (kDebugMode) {
      print('getToken ==> $accessToken');
    }
    // String? accessToken = SharedPref.instance.shared?.getString(SharePrefConstants.token);
    return accessToken;
  }

  Future<void> checkAndLogout() async {
    Future.delayed(
      Duration.zero,
      () async {
        if (userEntity == null) {
          AppFunctions().forceLogout();
          return;
        }
      },
    );
  }

  Future<void> forceLogout({bool onClearData = false}) async {
    if (currentRouteName == RouteList.login_screen) {
      return;
    }
    try {
      if (isAppBox) {
        appBox.clear();
        isAppBox = false;
      }
      if (isAppLanBox) {
        appLanBox.clear();
        isAppLanBox = false;
      }

      if (isCurrentLanBox) {
        currentLanBox.clear();
        isCurrentLanBox = false;
      }
      if (isUserDataBox) {
        userDataBox.clear();
        isUserDataBox = false;
      }
      if (isGeneralSettingBox) {
        generalSettingBox.clear();
        isGeneralSettingBox = false;
      }
      if (isAppActivityAnaltics) {
        appActivityAnaltics.clear();
        isAppActivityAnaltics = false;
      }

      appBox.put(HiveConstants.IS_FIRST_LOAD, false);

      userEntity = null;
    } on Exception catch (e) {
      log('forceLogout Try Catch ==> $e');
    }

    // if (FirebaseAuth.instance.currentUser != null) {
    //   await FirebaseAuth.instance.signOut();
    // }

    Catcher2.navigatorKey?.currentState?.popUntil((route) => (route.isFirst));
    CommonRouter.pushReplacementNamed(RouteList.login_screen);
  }

  static Future<void> uriHandler({required Uri uri}) async {
    initialLinkURI = uri;

    if (currentRouteName == RouteList.login_screen) {
      return;
    }

    if (userEntity == null) {
      await AppFunctions().forceLogout();
      return;
    }

    // if (userEntity != null) {
    //   if (isAppOpenFromDeeplink) {
    //     Catcher2.navigatorKey?.currentState?.popUntil((route) => route.isFirst);
    //     Catcher2.navigatorKey?.currentState?.pushReplacementNamed(RouteList.app_home);
    //     isAppOpenFromDeeplink = false;
    //   }
    //   return;
    // }

    Map<String, String> params = uri.queryParameters;

    String? screenName = (params['s'])?.toString();
    // String? companyName = (params['company'])?.toString();
    int? id = int.tryParse(params['code'].toString());
    debugPrint('=================> $params');
    if (screenName != null && id != null) {
      if (screenName == 'jobdetails' && id != 0) {
        //TODO deep Link Navigator Assign
        // Normal Product
        //   initialLinkURI = null;
        //   if (isAppOpenFromDeeplink) {
        //     CommonRouter.pushReplacementNamed(
        //       RouteList.job_detail_screen,
        //       arguments: JobDetailArgs(companyName: companyName ?? '', jobId: id),
        //     );
        //   } else {
        //     await CommonRouter.pushNamed(
        //       RouteList.job_detail_screen,
        //       arguments: JobDetailArgs(companyName: companyName ?? '', jobId: id),
        //     );
        //   }
        // } else if (screenName == 'shorts' && id != 0) {
        //   if (isAppOpenFromDeeplink) {
        //     await CommonRouter.pushReplacementNamed(
        //       RouteList.shorts_screen,
        //       arguments: ShortsScreenArgs(shortData: const [], index: 0, shortsId: id),
        //     );
        //   } else {
        //     await CommonRouter.pushNamed(
        //       RouteList.shorts_screen,
        //       arguments: ShortsScreenArgs(shortData: const [], index: 0, shortsId: id),
        //     );
        //   }
      } else if (isAppOpenFromDeeplink) {
        initialLinkURI = null;
        Catcher2.navigatorKey?.currentState?.popUntil((route) => route.isFirst);
        Catcher2.navigatorKey?.currentState?.pushReplacementNamed(RouteList.app_home);
      }
    } else if (isAppOpenFromDeeplink) {
      initialLinkURI = null;
      Catcher2.navigatorKey?.currentState?.popUntil((route) => route.isFirst);
      Catcher2.navigatorKey?.currentState?.pushReplacementNamed(RouteList.app_home);
    }
    isAppOpenFromDeeplink = false;
  }

  Future<Map<String, String>> initPlatformState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    deviceData = <String, String>{};
    try {
      if (Platform.isAndroid) {
        var data = await deviceInfoPlugin.androidInfo;
        deviceData = await _readAnroidDeviceInfo(data);
        await appBox.put(HiveConstants.DEVICE_DATA, deviceData);
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceData = _readIosDeviceInfo(data);
        await appBox.put(HiveConstants.DEVICE_DATA, deviceData);
      }
    } on PlatformException {
      deviceData = <String, String>{
        'device_model': "test",
        'systemVersion': "notfound",
        'device_type': Platform.isAndroid ? "android" : "ios",
        'device_id': deviceNotificationToken.toString().isEmpty ? 'notfound' : deviceNotificationToken.toString(),
        'unique_id': "notfound",
      };
      await appBox.put(HiveConstants.DEVICE_DATA, deviceData);
    }
    if (kDebugMode) {
      // print(deviceData);
    }

    if (deviceData != null && deviceData!.containsKey('device_id')) {
      if (deviceNotificationToken.toString().isEmpty) {
        deviceData!['device_id'] = 'notfound';
      } else {
        deviceData!['device_id'] = deviceNotificationToken.toString();
      }
    } else {
      if (deviceNotificationToken.toString().isEmpty) {
        deviceData!['device_id'] = 'notfound';
      } else {
        deviceData?.addAll({'device_id': deviceNotificationToken.toString()});
      }
    }

    return deviceData ??
        <String, String>{
          'device_model': "test",
          'systemVersion': "notfound",
          'device_type': Platform.isAndroid ? "android" : "ios",
          'device_id': deviceNotificationToken.toString().isEmpty ? 'notfound' : deviceNotificationToken.toString(),
          'unique_id': "notfound",
        };
  }

  Map<String, String> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, String>{
      'device_model': data.model,
      'systemVersion': data.systemVersion,
      'device_type': Platform.isAndroid ? "android" : "ios",
      'device_id': deviceNotificationToken.toString().isEmpty ? 'notfound' : deviceNotificationToken.toString(),
      'unique_id': data.identifierForVendor ?? 'unknown',
      'release': data.systemVersion.toString()
    };
  }

  Future<Map<String, String>> _readAnroidDeviceInfo(AndroidDeviceInfo data) async {
    const androidIdPlugin = AndroidId();
    final String? androidId = await androidIdPlugin.getId();

    // if (androidId != null) {
    //   appsflyerSdk.setAndroidIdData(androidId);
    // }

    return <String, String>{
      'device_model': data.model,
      'systemVersion': data.version.sdkInt.toString(),
      'device_type': Platform.isAndroid ? "android" : "ios",
      'device_id': deviceNotificationToken.toString().isEmpty ? 'notfound' : deviceNotificationToken.toString(),
      'unique_id': androidId?.toString() ?? 'notfound',
      'release': data.version.release.toString(),
    };
  }

  void cleanUpMemory() {
    ImageCache imageCache = PaintingBinding.instance.imageCache;

    if (imageCache.currentSizeBytes >= 55 << 20 || imageCache.currentSize >= 50) {
      imageCache.clear();
    }
    if (imageCache.liveImageCount >= 20) {
      imageCache.clearLiveImages();
    }
  }

  Future<void> incrementNotificationCount() async {
    int count = await getNotificationCount();
    prefs ??= await SharedPreferences.getInstance();
    if (prefs != null) {
      await (prefs)!.setInt('notifications_count', count + 1);
      totalNotificationCounts = (count + 1);
      if (badgeCounterProvider != null) {
        badgeCounterProvider!.reloadState();
      }
    }
  }

  Future<void> decrementNotificationCount() async {
    int count = await getNotificationCount();
    prefs ??= await SharedPreferences.getInstance();
    if (prefs != null) {
      (prefs)!.setInt('notifications_count', (count - 1 > 0 ? (count - 1) : 0));
      totalNotificationCounts = (count - 1 > 0 ? (count - 1) : 0);
      if (badgeCounterProvider != null) {
        badgeCounterProvider!.reloadState();
      }
    }
  }

  Future<int> getNotificationCount() async {
    prefs ??= await SharedPreferences.getInstance();
    if (prefs != null) {
      int totalNotificationCounts = (prefs)!.getInt('notifications_count') ?? 0;
      if (badgeCounterProvider != null) {
        badgeCounterProvider!.reloadState();
      }
      return totalNotificationCounts;
    }

    return 0;
  }

  Future<void> resetNotificationCount() async {
    prefs ??= await SharedPreferences.getInstance();
    if (prefs != null) {
      (prefs)!.setInt('notifications_count', 0);
      totalNotificationCounts = 0;
      if (badgeCounterProvider != null) {
        badgeCounterProvider!.reloadState();
      }
    }
  }
}
