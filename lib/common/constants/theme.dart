import 'package:flutter_project/domain/entities/theme_entity.dart';

enum Themes { light, dark, system }

class ThemesList {
  const ThemesList._();

  static const themeList = [
    ThemeEntity(key: "Light", theme: Themes.light),
    ThemeEntity(key: "Dark", theme: Themes.dark),
    ThemeEntity(key: "System", theme: Themes.system),
  ];
}
