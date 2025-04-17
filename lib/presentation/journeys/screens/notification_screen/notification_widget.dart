import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/data/models/app_model/my_notification_model.dart';
import 'package:flutter_project/presentation/provider/app_provider/notification_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/screens/notification_screen/notification_screen.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:provider/provider.dart';

abstract class NotificationWidget extends State<NotificationScreen> {
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    super.initState();
    notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationProvider.getNotificationHistory();
    });
    AppFunctions().resetNotificationCount();
  }

  @override
  void dispose() {
    super.dispose();
    notificationProvider.loadingProvider.hide();
  }

  Widget jobNotificationWidget({required NotificationData notification}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: appConstants.grey1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                notification.notification.title,
                style: Theme.of(context).textTheme.body1MediumHeading.copyWith(
                      color: appConstants.primary1Color,
                    ),
                overflow: TextOverflow.visible,
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              color: appConstants.grey1.withValues(alpha: 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Text(
                      notification.notification.body,
                      style: Theme.of(context).textTheme.caption1MediumHeading.copyWith(
                            color: appConstants.neutral5Color,
                          ),
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Divider(
                    color: appConstants.neutral9Color,
                    height: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(notification.createdAt),
                          style: Theme.of(context).textTheme.caption2MediumHeading.copyWith(
                                color: appConstants.neutral5Color,
                              ),
                          overflow: TextOverflow.visible,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),
                        CommonWidget.commonText(
                          text: DateFormat('hh:mm a').format(notification.createdAt),
                          style: Theme.of(context).textTheme.caption2MediumHeading.copyWith(
                                color: appConstants.neutral5Color,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
