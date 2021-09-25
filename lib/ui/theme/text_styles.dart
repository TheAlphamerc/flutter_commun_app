// ignore_for_file: avoid_classes_with_only_static_members

part of 'theme.dart';

class TextStyles {
  static TextStyle nameStyle(BuildContext context) =>
      context.textTheme.headline6!
          .copyWith(fontWeight: FontWeight.w700, fontSize: 18);

  static TextStyle bodyText14(BuildContext context) =>
      context.textTheme.bodyText1!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: context.themeType == ThemeType.LIGHT
              ? const Color(0xff424242)
              : Colors.white);

  static TextStyle bodyText15(BuildContext context) =>
      bodyText14(context).copyWith(
        fontSize: 15,
      );

  static TextStyle headline14(BuildContext context) =>
      headline16(context).copyWith(
        fontSize: 14,
      );
  static TextStyle headline16(BuildContext context) =>
      bodyText15(context).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
  static TextStyle headline15(BuildContext context) =>
      bodyText15(context).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );

  static TextStyle headline18(BuildContext context) =>
      headline16(context).copyWith(
        fontSize: 18,
      );
  static TextStyle headline20(BuildContext context) =>
      headline16(context).copyWith(
        fontSize: 20,
      );
  static TextStyle headline26(BuildContext context) =>
      headline16(context).copyWith(
        fontSize: 26,
      );
  static TextStyle headline30(BuildContext context) =>
      headline16(context).copyWith(
        fontSize: 30,
      );
  static TextStyle headline36(BuildContext context) =>
      headline16(context).copyWith(
        fontSize: 36,
      );
  static TextStyle subtitle14(BuildContext context,
          {FontWeight fontWeight = FontWeight.normal}) =>
      bodyText14(context).copyWith(
        fontWeight: fontWeight,
        color: context.themeType == ThemeType.LIGHT
            ? const Color(0xff919191)
            : Colors.white,
      );
  static TextStyle subtitle16(BuildContext context,
          {FontWeight fontWeight = FontWeight.normal}) =>
      subtitle14(context, fontWeight: fontWeight).copyWith(
        fontSize: 16,
      );
}
