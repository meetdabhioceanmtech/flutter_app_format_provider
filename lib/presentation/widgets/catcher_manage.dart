import 'package:catcher_2/handlers/console_handler.dart';
import 'package:catcher_2/handlers/discord_handler.dart';
import 'package:catcher_2/handlers/http_handler.dart';
import 'package:catcher_2/mode/silent_report_mode.dart';
import 'package:catcher_2/model/catcher_2_options.dart';
import 'package:catcher_2/model/http_request_type.dart';
import 'package:flutter_project/common/constants/env_constants.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:intl/intl.dart';

class CatcherManage {
  static final CatcherManage _instance = CatcherManage._internal();
  factory CatcherManage() => _instance;

  late final Catcher2Options releaseOptions;
  late final Catcher2Options debugOptions;

  CatcherManage._internal() {
    final now = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());

    final commonParams = {
      "user_id": userEntity?.id ?? "",
      "mobile_no": userEntity?.mobile ?? "",
      "token": userFcmToken ?? "",
      "datetime": now,
      "error_type": "app",
      "freeDiskSpace": "",
      "totalDiskSpace": "",
      "freeRam": "",
      "totalRam": "",
      "issue_type": "App Handled Exception",
      "model_name": deviceData?["device_model"] ?? "",
      "screen_name": currentRouteName,
      "api_endpoint": "",
    };

    final discordHandler = DiscordHandler(
      EnvConstants.DISCORD_WEBHOOK_URL,
      enableDeviceParameters: true,
      enableApplicationParameters: true,
      enableCustomParameters: true,
      enableStackTrace: true,
      printLogs: true,
    );

    releaseOptions = Catcher2Options(
      SilentReportMode(),
      [
        discordHandler,
        HttpHandler(
          HttpRequestType.post,
          Uri.parse("API URL Add"), //
          headers: {'Content-Type': 'application/json', "Accept": 'application/json'},
          enableCustomParameters: true,
          enableApplicationParameters: true,
          enableDeviceParameters: true,
          enableStackTrace: true,
          requestTimeout: const Duration(seconds: 3),
          responseTimeout: const Duration(seconds: 3),
        ),
      ],
      customParameters: commonParams,
    );

    debugOptions = Catcher2Options(
      SilentReportMode(),
      [
        discordHandler,
        ConsoleHandler(
          enableStackTrace: true,
          enableApplicationParameters: false,
          enableCustomParameters: false,
          enableDeviceParameters: false,
          handleWhenRejected: false,
        )
      ],
      customParameters: commonParams,
    );
  }
}
