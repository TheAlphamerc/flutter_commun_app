part of '../theme.dart';

// ignore: avoid_classes_with_only_static_members
class BoxDecorations {
  static BoxDecoration decoration(
    BuildContext context, {
    Offset offset = const Offset(4, 4),
    double blurRadius = 10,
    double borderRadius = 5,
  }) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: const Color(0xffeaeaea),
              blurRadius: blurRadius,
              offset: offset)
        ],
      );

  static BoxDecoration outlineBorder(BuildContext context,
          {double width = 2, Color? color, double radius = 5}) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: color ?? Theme.of(context).dividerColor, width: width),
      );
}
