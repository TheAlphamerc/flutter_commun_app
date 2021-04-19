import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
export 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'color/light_colors.dart';
part 'text_styles.dart';
part 'extention.dart';

enum ThemeType { LIGHT, DARK }

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        brightness: Brightness.light,
        primaryColor: KColors.primary,
        primaryColorLight: KColors.primaryLight,
        buttonColor: KColors.primary,
        backgroundColor: KColors.background,
        cardColor: KColors.cardColor,
        errorColor: KColors.errorColor,
        iconTheme: IconThemeData(color: KColors.icon),
        colorScheme: ThemeData.light().colorScheme.copyWith(
            surface: KColors.surfaceColor,
            onSurface: KColors.onSurfaceDarkColor,
            onPrimary: KColors.onPrimary,
            onSecondary: KColors.onPrimary,
            onBackground: KColors.onSurfaceLightColor),
        // textTheme: TextThemes.lightTextTheme,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              color: KColors.appBarColor,
              elevation: 1,
              titleTextStyle: TextStyle(
                fontSize: 18,
                color: KColors.bodyTextColor,
              ),
            ),
        primaryTextTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: TextStyle(color: KColors.dark_gray),
            ),
      );

  static ThemeData getThemeFromKey(ThemeType themeKey) {
    switch (themeKey) {
      case ThemeType.LIGHT:
        return lightTheme;
      case ThemeType.DARK:
        return lightTheme;
      default:
        return lightTheme;
    }
  }
}
