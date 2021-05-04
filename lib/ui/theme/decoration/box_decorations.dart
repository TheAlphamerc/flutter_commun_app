part of '../theme.dart';

class BoxDecorations {
  static BoxDecoration decoration(BuildContext context,
          {Offset offset = const Offset(4, 4), double blurRadius = 10}) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: const Color(0xffeaeaea),
              blurRadius: blurRadius,
              offset: offset)
        ],
      );

  static BoxDecoration outlineBorder(BuildContext context,
          {double width = 2, Color color, double radius = 5}) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: color ?? Theme.of(context).dividerColor, width: width),
      );
}
