import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/common/constants/env_constants.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';

class ApiConstatnts {
  static final String baseUrl = dotenv.env[EnvConstants.BASE_URL] ?? '';
  static final String liveBaseUrl = dotenv.env[EnvConstants.LIVE_BASE_URL] ?? '';
  static final String xLocalization = dotenv.env[EnvConstants.X_LOCALIZATION] ?? '';
  static final String accept = dotenv.env[EnvConstants.ACCEPT] ?? '';
  var headers = {
    "X-localization": xLocalization,
    "Accept": accept,
    "Content-Type": accept,
    "Authorization": 'Bearer ${AppFunctions().getUserToken() ?? ''}',
  };
}
