class NotificationModel {
  String image;
  String title;
  String detail;
  String type;
  bool hasNavigationLink;
  DateTime dateTime;
  String companyId;
  String companyName;

  NotificationModel({
    required this.image,
    required this.title,
    required this.detail,
    required this.type,
    required this.hasNavigationLink,
    required this.dateTime,
    required this.companyId,
    required this.companyName,
  });
}
