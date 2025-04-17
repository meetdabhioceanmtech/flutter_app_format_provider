import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/app_model/my_notification_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extension/string_extension.dart';
import 'package:flutter_project/presentation/provider/app_provider/notification_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/screens/notification_screen/notification_widget.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:flutter_project/presentation/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends NotificationWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        onTap: () => CommonRouter.pop(),
        title: TranslationConstants.my_notifications.translate(context),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: appConstants.primary1Color));
          } else if (provider.errorMessage != null) {
            return CommonWidget.dataNotFound(
              context: context,
              bgColor: appConstants.whiteBackgroundColor,
              heading: TranslationConstants.something_went_wrong.translate(context),
              subHeading: provider.errorMessage!,
              buttonLabel: TranslationConstants.try_again.translate(context),
              onTap: () async => await provider.getNotificationHistory(),
            );
          } else if (provider.notificationList.isEmpty) {
            return CommonWidget.sizedBox(
              child: CommonWidget.dataNotFound(
                imagePath: 'assets/svgs/common/data_not_found.svg',
                heading: TranslationConstants.no_data_found.translate(context),
                subHeading: TranslationConstants.hint_no_notification.translate(context),
                context: context,
                actionButton: const SizedBox.shrink(),
              ),
            );
          } else {
            return SizedBox(
              height: ScreenUtil.defaultSize.height,
              child: RefreshIndicator(
                onRefresh: () async => await provider.getNotificationHistory(isRefreshIndicator: true),
                color: appConstants.primary1Color,
                backgroundColor: appConstants.grayBackgroundColor,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: provider.notificationList.length,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemBuilder: (context, index) {
                    NotificationData notification = provider.notificationList[index];
                    return jobNotificationWidget(notification: notification);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10.h);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
