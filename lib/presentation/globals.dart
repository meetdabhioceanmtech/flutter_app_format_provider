import 'dart:async';
import 'dart:isolate';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/theme.dart';
import 'package:flutter_project/presentation/provider/app_provider/language_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter_project/domain/entities/general_setting/general_setting_entity.dart';
import 'package:flutter_project/presentation/provider/common_provider/counter_provider.dart';
import 'package:flutter_project/core/api/build_context.dart';
import 'package:flutter_project/domain/entities/user/user_entity.dart';
import 'package:flutter_project/presentation/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

late Box appBox;
bool isAppBox = false;
late Box appLanBox;
bool isAppLanBox = false;
late Box userDataBox;
bool isUserDataBox = false;
late Box generalSettingBox;
bool isGeneralSettingBox = false;
late Box currentLanBox;
bool isCurrentLanBox = false;
late Box appActivityAnaltics;
bool isAppActivityAnaltics = false;
bool isFirst = true;

int jobOpenCount = 0;
int navigationCount = 0;

late bool? isInterestDone;
late int launchNo;
late bool? isDarkMode;
late FirebaseAnalytics? firebaseAnalytics;
String languageLocalPath = '';
bool locationPermission = false;

Map<String, String>? deviceData;
bool isNewTemplateLoaded = false;
// FreePlanAds? freePlanAds;
bool isStory = false;
String deviceNotificationToken = '';

Map<dynamic, dynamic>? intentData;
bool isCRM = false;
String? crmMobileNo = '';
String? crmMemberId = '';
String appSignature = 'oceanmtechdmt_signature';
String globalDownloadLocation = '';

UserEntity? userEntity;

int? initialLoginMobileNo;
String? mobileNo;

late AppConstants appConstants;

StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
StreamController<InternetStatus>? connnectionController = StreamController<InternetStatus>.broadcast();
FocusScopeNode currentFocus = FocusScope.of(buildContext);

enum InternetStatus { connected, notConnected }

bool showConnectionMessage = false;
ConnectivityResult? connectivityResult;
bool isConnectionSuccessful = true;

String? userToken;
String? userFcmToken;

SharedPreferences? prefs;
int totalNotificationCounts = 0;

int routeDuration = 0;
Isolate? routeIsolate;
final routingIsolateReceivePort = ReceivePort();
final postIsolateReceivePort = ReceivePort();
final ReceivePort receivePort = ReceivePort();

Themes currentTheme = Themes.system;

class Message {
  String message;
  SendPort sendPort;
  int oldDuration;

  Message({
    required this.message,
    required this.sendPort,
    required this.oldDuration,
  });
}

Map<String, int> userAppActivity = {};
String? currentRouteName;
Object? routeArguments;

bool isTourCompleted = false;

CounterProvider? badgeCounterProvider;

Uri? initialLinkURI;
bool isAppOpenFromDeeplink = false;

FirebaseMessaging messaging = FirebaseMessaging.instance;

String notificationKey = "getNotification";

GeneralSettingEntity? generalSettingEntity;
bool appNotification = true;

// Language Management
dynamic currentLanguagelabels;
late String currentLangCode;
late LanguageProvider languageProvider;
