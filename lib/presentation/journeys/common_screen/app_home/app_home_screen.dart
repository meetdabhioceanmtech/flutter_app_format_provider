import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extension/string_extension.dart';
import 'package:flutter_project/presentation/provider/app_provider/bottom_navigation_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/common_screen/app_home/app_home_widget.dart';
import 'package:flutter_project/presentation/journeys/screens/bottom_navbar/bottom_nav_constants.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:provider/provider.dart';

class AppHome extends StatefulWidget {
  final bool? check;
  const AppHome({super.key, this.check});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends AppHomeWidget {
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final provider = Provider.of<BottomNavigationProvider>(context, listen: false);

        if (didPop) return;
        final NavigatorState navigator = Navigator.of(context);
        if (provider.currentIndex == 0) {
          var result = await CommonWidget.showAlertDialog(
            context: context,
            isTitle: true,
            title: TranslationConstants.company_app.translate(context),
            subTitle: TranslationConstants.exit_msg.translate(context),
          );
          if (result == true) {
            if (Platform.isAndroid) {
              generalSettingBox.clear();
              appActivityAnaltics.clear();

              navigator.popUntil((route) => route.isFirst);
              SystemNavigator.pop();
            } else {
              navigator.popUntil((route) => route.isFirst);
              SystemNavigator.pop();
            }
          }
        } else {
          provider.changeIndex(0);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appConstants.whiteBackgroundColor,
        endDrawerEnableOpenDragGesture: false,
        body: Consumer<BottomNavigationProvider>(
          builder: (context, provider, child) {
            return IndexedStack(index: provider.currentIndex, children: bottomScreenList);
          },
        ),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }
}
