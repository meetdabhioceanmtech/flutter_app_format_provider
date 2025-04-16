import 'dart:async';
import 'dart:io';
import 'package:catcher_2/core/catcher_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/route_constants.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/new_notification_service.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  File? splashImage;
  int duration = 5;
  String splashUrl = "";

  @override
  void initState() {
    super.initState();
    setImageInLocal();
    Future.delayed(Duration.zero, () async {
      await initialMessage(context: context);
      startTimer();
    });
  }

  Future<void> setImageInLocal() async {
    splashUrl = await appBox.get(HiveConstants.SPLASH_IMAGE_PATH) ?? "";
    if (splashUrl.isEmpty || splashUrl == 'null') return;
    final directory = '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}splash';
    File file = File('$directory${Platform.pathSeparator}${splashUrl.split('/').last}');

    if (!await file.exists() && splashUrl.startsWith('https')) {
      try {
        final parentDir = Directory(directory);
        if (await parentDir.exists()) {
          await parentDir.delete(recursive: true);
        }
        await file.create(recursive: true);
        Client client = Client();
        var response = await client.get(Uri.parse(splashUrl));
        await file.writeAsBytes(response.bodyBytes);
      } catch (e) {
        if (await file.exists()) {
          await file.delete();
        }
      }
    } else {
      splashImage = file;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appConstants.whiteBackgroundColor,
      body: Center(
        child: CommonWidget.imageBuilder(
          image:
              (splashImage != null && splashImage?.path != null) ? splashImage!.path : "assets/pngs/common/splash.png",
          fit: BoxFit.cover,
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
        ),
      ),
    );
  }

  Future<void> startTimer() async {
    if (isOpenFromNotification && remoteMessage != null) {
      await handleSplashNavigation();
      await PushNotificationService().handleDirectNotification(message: remoteMessage!);
    }
    Timer(
      Duration(seconds: duration),
      () async {
        //TODO General Setting API
        // BlocProvider.of<GeneralSettingCubit>(context).getGeneralSetting();

        if (userToken == null) {
          CommonRouter.pushReplacementNamed(RouteList.login_screen);
        } else {
          CommonRouter.pushReplacementNamed(RouteList.app_home);
        }
      },
    );
  }

  Future<void> handleSplashNavigation() async {
    if (!mounted) return;
    if (!isTourCompleted && userToken == null) {
      AppFunctions().forceLogout();
    } else {
      if (initialLinkURI != null) {
        isAppOpenFromDeeplink = true;
        await AppFunctions.uriHandler(uri: initialLinkURI!);
      } else {
        Catcher2.navigatorKey?.currentState?.pushReplacementNamed(RouteList.app_home);
      }
    }
  }
}
