import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
// ignore: directives_ordering
export 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'color/light_colors.dart';
part 'text_styles.dart';
part 'extention.dart';
part 'decoration/box_decorations.dart';

// ignore: constant_identifier_names
enum ThemeType { LIGHT, DARK }

mixin AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        brightness: Brightness.light,
        primaryColor: KColors.primary,
        primaryColorLight: KColors.primaryLight,
        buttonColor: KColors.primary,
        backgroundColor: KColors.background,
        cardColor: KColors.cardColor,
        errorColor: KColors.errorColor,
        iconTheme: const IconThemeData(color: KColors.icon),
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
              titleTextStyle: const TextStyle(
                fontSize: 18,
                color: KColors.bodyTextColor,
              ),
            ),
        primaryTextTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(color: KColors.dark_gray),
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
