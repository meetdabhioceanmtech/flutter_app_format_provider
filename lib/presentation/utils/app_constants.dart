// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';

class AppConstants {
  AppConstants() : super() {
    loadColor(true);
  }
  String loctionApiKey = 'AIzaSyA6vKEF9G12zSbgsJBcTxUVXvGzlnBnMJ4';
  FontWeight appFontWeight = FontWeight.bold;
  FontWeight appFontW800 = FontWeight.w800;
  double iconSize = 32;
  double fontSize = 20;
  String intentDataChannel = "app.channel.shared.data.job";
  String intentDataChannelMethod = "getSharedText";
  IconThemeData appIconThemeData = IconThemeData(size: 26);

  double buttonRadius = 12;
  double prductCardRadius = 10;
  Color _neutralColor = Color((int.parse('0xff293847')));
  Color _primaryColor = Color((int.parse('0xff084277')));
  Color _secondaryColor = Color((int.parse('0xff4392F1')));

  Color _neutralColorDark = Color((int.parse('0xff242F3E')));
  Color _primaryColorDark = Color((int.parse('0xff5D6A7C')));
  Color _secondaryColorDark = Color((int.parse('0xff5D6A7C')));
  Color _red = Colors.red;
  Color _green = Colors.green;
  Color _grey1 = Color(0xff797979);
  Color _grey2 = Color(0xffBCBCBC);
  Color _grayBackgroundColor = Color(0xffF4F4F4);

  late Color primary1Color;
  late Color primary2Color;
  late Color primary3Color;
  late Color primary4Color;
  late Color primary5Color;
  late Color primary6Color;
  late Color primary7Color;
  late Color primary8Color;

  late Color secondary1Color;
  late Color secondary2Color;
  late Color secondary3Color;
  late Color secondary4Color;
  late Color secondary5Color;
  late Color secondary6Color;
  late Color secondary7Color;
  late Color secondary8Color;

  late Color neutral1Color;
  late Color neutral2Color;
  late Color neutral3Color;
  late Color neutral4Color;
  late Color neutral5Color;
  late Color neutral6Color;
  late Color neutral7Color;
  late Color neutral8Color;
  late Color neutral9Color;
  late Color neutral10Color;

  late Color whiteBackgroundColor;
  late Color grayBackgroundColor;
  late Color redColor;
  late Color greenColor;
  late Color grey1;
  late Color grey2;

  void loadColor(bool isLightMode) {
    print(isLightMode);
    if (isLightMode) {
      loadLight();
    } else {
      loadDark();
    }
  }

  void loadLight() {
    primary1Color = _primaryColor;
    primary2Color = _primaryColor.withValues(alpha: 0.80);
    primary3Color = _primaryColor.withValues(alpha: 0.60);
    primary4Color = _primaryColor.withValues(alpha: 0.40);
    primary5Color = _primaryColor.withValues(alpha: 0.30);
    primary6Color = _primaryColor.withValues(alpha: 0.20);
    primary7Color = _primaryColor.withValues(alpha: 0.10);
    primary8Color = _primaryColor.withValues(alpha: 0.05);

    secondary1Color = _secondaryColor;
    secondary2Color = _secondaryColor.withValues(alpha: 0.80);
    secondary3Color = _secondaryColor.withValues(alpha: 0.60);
    secondary4Color = _secondaryColor.withValues(alpha: 0.40);
    secondary5Color = _secondaryColor.withValues(alpha: 0.30);
    secondary6Color = _secondaryColor.withValues(alpha: 0.20);
    secondary7Color = _secondaryColor.withValues(alpha: 0.10);
    secondary8Color = Colors.white;

    neutral1Color = _neutralColor;
    neutral2Color = _neutralColor.withValues(alpha: 0.90);
    neutral3Color = _neutralColor.withValues(alpha: 0.80);
    neutral4Color = _neutralColor.withValues(alpha: 0.70);
    neutral5Color = _neutralColor.withValues(alpha: 0.60);
    neutral6Color = _neutralColor.withValues(alpha: 0.50);
    neutral7Color = _neutralColor.withValues(alpha: 0.40);
    neutral8Color = _neutralColor.withValues(alpha: 0.30);
    neutral9Color = _neutralColor.withValues(alpha: 0.20);
    neutral10Color = Colors.white;

    whiteBackgroundColor = Colors.white;

    redColor = _red;
    greenColor = _green;
    grey1 = _grey1;
    grey2 = _grey2;
    grayBackgroundColor = _grayBackgroundColor;
  }

  void loadDark() {
    primary1Color = _primaryColorDark;
    primary2Color = _primaryColorDark.withValues(alpha: 0.80);
    primary3Color = _primaryColorDark.withValues(alpha: 0.60);
    primary4Color = _primaryColorDark.withValues(alpha: 0.40);
    primary5Color = _primaryColorDark.withValues(alpha: 0.30);
    primary6Color = _primaryColorDark.withValues(alpha: 0.20);
    primary7Color = _primaryColorDark.withValues(alpha: 0.10);
    primary8Color = _primaryColorDark.withValues(alpha: 0.05);

    secondary1Color = _secondaryColorDark;
    secondary2Color = _secondaryColorDark.withValues(alpha: 0.80);
    secondary3Color = _secondaryColorDark.withValues(alpha: 0.60);
    secondary4Color = _secondaryColorDark.withValues(alpha: 0.40);
    secondary5Color = _secondaryColorDark.withValues(alpha: 0.30);
    secondary6Color = _secondaryColorDark.withValues(alpha: 0.20);
    secondary7Color = _secondaryColorDark.withValues(alpha: 0.10);
    secondary8Color = Colors.white;

    neutral1Color = _neutralColorDark;
    neutral2Color = _neutralColorDark.withValues(alpha: 0.70);
    neutral3Color = _neutralColorDark.withValues(alpha: 0.60);
    neutral4Color = _neutralColorDark.withValues(alpha: 0.41);
    neutral5Color = _neutralColorDark.withValues(alpha: 0.30);
    neutral6Color = _neutralColorDark.withValues(alpha: 0.17);
    neutral7Color = _neutralColorDark.withValues(alpha: 0.14);
    neutral8Color = _neutralColorDark.withValues(alpha: 0.11);
    neutral9Color = _neutralColorDark.withValues(alpha: 0.08);
    neutral10Color = _neutralColorDark.withValues(alpha: 0.06);

    redColor = _red;
    greenColor = _green;
    grey1 = _grey1;
    grey2 = _grey2;
    grayBackgroundColor = _grayBackgroundColor;
  }
}
