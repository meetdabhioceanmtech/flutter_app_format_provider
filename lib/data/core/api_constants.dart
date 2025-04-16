import 'package:flutter_project/presentation/utils/app_functions.dart';

class ApiConstatnts {
  static const String baseUrl = 'https://bakery.oceanapplications.com/api/v1/';
  static const String liveBaseUrl = 'https://bakery.oceanapplications.com/api/v1/';
  static const String xLocalization = 'en';
  static const String accept = 'application/json';
  static const String salt = 'VhU8dwzsjHQC8mRFGdJzsYtHDGZ5KVlZA';

  var headers = {
    "X-localization": xLocalization,
    "Accept": accept,
    "Content-Type": accept,
    "Authorization": 'Bearer ${AppFunctions().getUserToken() ?? ''}',
  };
}
