import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/index.dart';
export 'package:flutter_commun_app/ui/theme/index.dart';
export 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'color/light_colors.dart';
part 'decoration/box_decorations.dart';
part 'text_styles.dart';

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
        floatingActionButtonTheme: ThemeData.light()
            .floatingActionButtonTheme
            .copyWith(backgroundColor: KColors.primary),
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
        bottomSheetTheme: ThemeData.light().bottomSheetTheme.copyWith(
              backgroundColor: KColors.bottomSheetDialogBcg,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
