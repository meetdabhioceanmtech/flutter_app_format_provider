import 'package:app_links/app_links.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';

class AppLinksService {
  static init() async {
    AppLinks appLinks = AppLinks();
    initialLinkURI = (await appLinks.getInitialLink()) ?? (await appLinks.getLatestLink());
    appLinks.uriLinkStream.listen((uri) async => await AppFunctions.uriHandler(uri: uri));
  }
}
