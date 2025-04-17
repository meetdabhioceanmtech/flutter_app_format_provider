import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/route_constants.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extension/string_extension.dart';
import 'package:flutter_project/common/extension/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:flutter_project/presentation/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (userEntity == null) {
      // BlocProvider.of<ProfileCubit>(context).getProfile();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appConstants.grayBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(
        context: context,
        title: TranslationConstants.company_app.translate(context),
        appBarColor: appConstants.primary1Color,
        textColor: appConstants.whiteBackgroundColor,
        titleCenter: false,
        backArrow: false,
        actions: InkWell(
          onTap: () async => await CommonRouter.pushNamed(RouteList.notification_screen),
          focusColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: SizedBox(
            height: 45.h,
            width: 45.h,
            child: Padding(
              padding: EdgeInsets.all(11.r),
              child: Badge(
                backgroundColor: totalNotificationCounts != 0 ? Colors.red : Colors.transparent,
                isLabelVisible: totalNotificationCounts == 0 ? false : true,
                largeSize: 13,
                offset: const Offset(1, -3),
                label: Text(
                  totalNotificationCounts.toString(),
                  style: Theme.of(context).textTheme.h4BoldHeading.copyWith(
                        color: appConstants.whiteBackgroundColor,
                        fontSize: 10.sp,
                        height: 1,
                      ),
                ),
                child: CommonWidget.imageBuilder(
                  image: "assets/svgs/common/notification.svg",
                  height: 20.h,
                ),
              ),
            ),
          ),
        ),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
