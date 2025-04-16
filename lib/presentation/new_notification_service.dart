// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
var initSettings;

bool isOpenFromNotification = false;
RemoteMessage? remoteMessage;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

initialMessage({required BuildContext context}) async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null && initialMessage.data.isNotEmpty) {
    isOpenFromNotification = true;
    remoteMessage = initialMessage;
  }

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if ((notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) &&
      notificationAppLaunchDetails?.notificationResponse?.payload != null) {
    isOpenFromNotification = true;
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.notificationResponse != null &&
        notificationAppLaunchDetails.notificationResponse?.payload != null) {
      remoteMessage = RemoteMessage(
        data: Map<String, dynamic>.from(jsonDecode(notificationAppLaunchDetails.notificationResponse?.payload ?? "")),
      );
    }
  }

  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {
      print('>>>>>>>>>>>>>>>>>>> FirebaseMessaging.onMessageOpenedApp');
      if (event.data.containsKey("af-uinstall-tracking")) {
        return;
      } else {
        PushNotificationService().handleDirectNotification(message: event);
      }
    },
  );
}

class PushNotificationService {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Importance',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  bool _initialized = false;

  Future<void> setupInteractedMessage() async {
    if (_initialized) return;
    _initialized = true;

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('>>>>>>>>>>>>>>>>>>> FirebaseMessaging.onMessageOpenedApp');
        if (message.data.containsKey("af-uinstall-tracking")) {
          return;
        } else {
          handleDirectNotification(message: message);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      print('>>>>>>>>>>>>>>>>>>> FirebaseMessaging.onMessage');
      if (message?.data.containsKey("af-uinstall-tracking") ?? false) {
        return;
      } else {
        if (Platform.isAndroid) {
          await sendLocalNotification(message: message);
        } else {
          await setNotificationData(data: message);
        }
      }
    });

    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) async {
      //   if (payload != null) {
      //     notificationCubit.updateSelectedMessage(payloadModel: NotificationPayloadModel.fromJson(jsonDecode(payload)));
      //   }
      // },
    );
    initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    // final notificationProvider = Provider.of<SelectedNotificationProvider>(context, listen: false);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        if (payload.payload != null) {
          try {
            // NotificationPayloadModel payloadModel =
            //     NotificationPayloadModel.fromJson(jsonDecode(payload.payload ?? ""));
            // notificationProvider.updateSelectedMessage(newPayloadModel: payloadModel);
          } on Exception {
            // notificationProvider.updateSelectedMessage(newPayloadModel: null);
          }
        }
      },
    );
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> handleDirectNotification({required RemoteMessage message}) async {
    //   final notificationProvider = Provider.of<SelectedNotificationProvider>(context, listen: false);
    //   AnalyticsService().appOpenFromNotification();
    //   try {
    //     NotificationPayloadModel payloadModel = NotificationPayloadModel.fromJson(message.data);
    //     notificationProvider.updateSelectedMessage(newPayloadModel: payloadModel);
    //   } on Exception {
    //     notificationProvider.updateSelectedMessage(newPayloadModel: null);
    //   }
  }

  Future<String> _base64encodedImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final String base64Data = base64Encode(response.bodyBytes);
    return base64Data;
  }

  Future<void> sendLocalNotification({RemoteMessage? message}) async {
    print('>>>>>>>>>>>>>>>>>>> sendLocalNotification');

    if (message?.data.containsKey("af-uinstall-tracking") ?? false) {
      return;
    }

    RemoteNotification? notification = message?.notification;
    AndroidNotification? android = message?.notification?.android;
    AppleNotification? ios = message?.notification?.apple;

    await setNotificationData(data: message);
    commonPrint("Data: ${message?.data ?? ''}");
    commonPrint("notificationData: $notification");

    if (notification != null && android != null) {
      Map<String, dynamic>? data = message?.data;

      String? imageUrl = data?["image"] ?? android.imageUrl;
      String title = data?["title"] ?? notification.title;
      String body = data?["body"] ?? notification.body;

      BigPictureStyleInformation? bigPictureStyleInformation;
      BigTextStyleInformation? bigTextStyleInformation;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        final String bigPicture = await _base64encodedImage(imageUrl);

        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(bigPicture),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(bigPicture),
          summaryText: title,
          contentTitle: body,
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
          htmlFormatContent: true,
          htmlFormatTitle: true,
        );
      } else {
        bigTextStyleInformation = BigTextStyleInformation(
          body,
          contentTitle: title.boldTag(),
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
          htmlFormatBigText: true,
          htmlFormatContent: true,
          htmlFormatTitle: true,
        );
      }

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title.removeHTMLTag(),
        body.removeHTMLTag(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            styleInformation: bigPictureStyleInformation ?? bigTextStyleInformation,
          ),
        ),
        payload: json.encode(message?.data),
      );
    } else if (notification != null && ios != null) {
      Map<String, dynamic>? data = message?.data;

      String title = data?["title"] ?? notification.title;
      String body = data?["body"] ?? notification.body;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title.removeHTMLTag(),
        body.removeHTMLTag(),
        const NotificationDetails(),
        payload: json.encode(message?.data),
      );
    } else if ((message?.data.isNotEmpty ?? false) && notification == null && android == null) {
      Map<String, dynamic>? data = message?.data;

      BigPictureStyleInformation? bigPictureStyleInformation;
      if (data?["image"] != null) {
        final String bigPicture = await _base64encodedImage(data?["image"]);

        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(bigPicture),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(bigPicture),
          summaryText: data?["title"] ?? '',
          contentTitle: data?["body"] ?? '',
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
          htmlFormatContent: true,
          htmlFormatTitle: true,
        );
      }

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        data?["title"] ?? '',
        data?["body"] ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            styleInformation: bigPictureStyleInformation,
          ),
        ),
        payload: json.encode(message?.data),
      );
    }
  }
}

Future<void> setNotificationData({required RemoteMessage? data}) async {
  if (data?.data.isEmpty ?? false) return;

  log(data.toString());
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String> listOfNotification = [];
  listOfNotification.addAll(await getNotificationData());
  print("====> Data: $data");
  print("====> Data Data: ${data?.data}");
  print("====> Body: ${data?.notification}");
  print("====> Body: ${data?.toMap()}");
  Map<String, dynamic> notificationData = {
    '"image"': '"${data?.data['image']?.toString() ?? ''}"',
    '"company_name"': '"${data?.data['company_name']?.toString() ?? ''}"',
    '"company_id"': '"${data?.data['company_id']?.toString() ?? ''}"',
    '"type"': '"${data?.data['type']?.toString() ?? ''}"',
    '"title"': '"${data?.notification?.title?.toString() ?? ''}"',
    '"body"': '"${data?.notification?.body?.toString() ?? ''}"',
    '"date"': '"${DateTime.now()}"',
    '"remoteMessage"': '"${data?.toMap()}"'
  };
  AppFunctions().incrementNotificationCount();
  listOfNotification.add(notificationData.toString());
  await sharedPreferences.setStringList(notificationKey, listOfNotification);
}

Future<List<String>> getNotificationData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String> l1 = sharedPreferences.getStringList(notificationKey) ?? [];
  return l1;
}

class NotificationPayloadModel {
  String? image;
  String? title;
  String? body;
  String? type;
  String? sound;
  String? icon;
  String? customerName;
  String? customerId;

  NotificationPayloadModel({
    this.image,
    this.title,
    this.body,
    this.type,
    this.sound,
    this.icon,
    this.customerId,
    this.customerName,
  });

  static NotificationPayloadModel fromJson(Map<String, dynamic> data) {
    return NotificationPayloadModel(
      image: data['image']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      body: data['body']?.toString() ?? '',
      type: data['type']?.toString() ?? '',
      sound: data['sound']?.toString() ?? '',
      icon: data['icon']?.toString() ?? '',
      customerId: data['company_id']?.toString() ?? '',
      customerName: data['company_name']?.toString() ?? '',
    );
  }
}
