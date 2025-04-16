// Class to represent the parsed JSON
import 'package:flutter_project/data/models/model_response_extend.dart';

class MyNotification extends ModelResponseExtend {
  bool status;
  String message;
  Data data;

  MyNotification({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) => MyNotification(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
        data: Data.fromJson(json["data"]),
      );
}

// Class to represent data
class Data {
  final List<NotificationData> notifications;

  Data({
    required this.notifications,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notifications: List<NotificationData>.from(json["notifications"].map((x) => NotificationData.fromJson(x))),
      );
}

// Class to represent notification data
class NotificationData {
  final int id;
  final String companyId;
  final String companyName;
  final NotificationDetail notification;
  final DateTime createdAt;

  NotificationData({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.notification,
    required this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        id: json["id"] ?? 0,
        companyId: json["company_id"] ?? '',
        companyName: json["company_name"] ?? '',
        notification: NotificationDetail.fromJson(json["notification"]),
        createdAt: DateTime.parse(json["created_at"]),
      );
}

// Class to represent notification detail
class NotificationDetail {
  final String title;
  final String body;
  final String type;
  final String? image;
  final String companyId;
  final String companyName;
  final String clickAction;

  NotificationDetail({
    required this.title,
    required this.body,
    required this.type,
    this.image,
    required this.companyId,
    required this.companyName,
    required this.clickAction,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) => NotificationDetail(
        title: json["title"] ?? '',
        body: json["body"] ?? '',
        type: json["type"] ?? '',
        image: json["image"],
        companyId: json["company_id"] ?? '',
        companyName: json["company_name"] ?? '',
        clickAction: json["click_action"] ?? '',
      );
}
