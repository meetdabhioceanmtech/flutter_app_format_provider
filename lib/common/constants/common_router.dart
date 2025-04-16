import 'package:catcher_2/catcher_2.dart';

class CommonRouter {
  CommonRouter._();
  static void pop({Object? args}) {
    Catcher2.navigatorKey?.currentState?.pop(args);
  }

  static Future<Object?> pushNamed(String routeName, {Object? arguments}) async {
    Object? data = await Catcher2.navigatorKey?.currentState?.pushNamed(routeName, arguments: arguments);
    return data;
  }

  static Future<void> pushReplacementNamed(String routeName, {Object? arguments}) async {
    await Catcher2.navigatorKey?.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(String routeName) {
    Catcher2.navigatorKey?.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  static void popUntil(String routeName) {
    Catcher2.navigatorKey?.currentState?.popUntil(
      (route) => route.settings.name == routeName,
    );
  }
}
