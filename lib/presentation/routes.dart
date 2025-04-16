import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/route_constants.dart';
import 'package:flutter_project/presentation/journeys/screens/login_screen/login_screen.dart';
import 'package:flutter_project/presentation/journeys/app_home/app_home_screen.dart';
import 'package:flutter_project/presentation/journeys/screens/notification_screen/notification_screen.dart';
import 'package:flutter_project/presentation/journeys/screens/privacy_and_terms/privacy_and_terms_screen.dart';
import 'package:flutter_project/presentation/journeys/screens/select_language/language_screen.dart';
import 'package:flutter_project/presentation/journeys/screens/image_crop/crop_image_screen.dart';
import 'package:flutter_project/presentation/journeys/screens/image_crop/image_crop_args.dart';
import 'package:flutter_project/presentation/journeys/screens/splash_screen/splash_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => const SplashScreen(),
        RouteList.app_home: (context) => const AppHome(),
        RouteList.login_screen: (context) => const LoginScreen(),
        RouteList.image_crop_screen: (context) => CropImageScreen(cropArgs: setting.arguments as ImageCropArgs),
        RouteList.privacy_and_terms_screen: (context) =>
            PrivacyAndTermsScreen(typeScreen: setting.arguments as TypeScreen),
        RouteList.language_screen: (context) => const LanguageScreen(),
        RouteList.notification_screen: (context) => const NotificationScreen(),
      };
}
