import 'package:flutter/material.dart';
import 'package:flutter_project/core/notifications/new_notification_service.dart';

class SelectedNotificationProvider extends ChangeNotifier {
  NotificationPayloadModel? payloadModel;

  NotificationPayloadModel? get getPayloadModel => payloadModel;

  void updateSelectedMessage({required NotificationPayloadModel? newPayloadModel}) {
    payloadModel = newPayloadModel;
    notifyListeners();
  }
}
