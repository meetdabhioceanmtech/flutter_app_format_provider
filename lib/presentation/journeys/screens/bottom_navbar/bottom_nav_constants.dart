import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/presentation/journeys/screens/bottom_navbar/nav_title_widget.dart';
import 'package:flutter_project/presentation/journeys/screens/home/home_screen.dart';

List<NavItems> bottomBarItems = const [
  NavItems(
    index: 0,
    title: TranslationConstants.home,
    icon: 'assets/svgs/common/home.svg',
  ),
  NavItems(
    index: 1,
    title: TranslationConstants.recharge,
    icon: 'assets/svgs/common/recharge.svg',
  ),
  NavItems(
    index: 2,
    title: TranslationConstants.setting,
    icon: 'assets/svgs/common/setting.svg',
  ),
];

final bottomScreenList = [
  const HomeScreen(),
  const SizedBox(),
  const SizedBox(),
];
