import 'package:flutter/material.dart';

class KFlatButton extends StatelessWidget {
  const KFlatButton({
    Key? key,
    this.onPressed,
    required this.label,
    this.isLoading,
    this.color,
    this.labelStyle,
    this.borderRadius,
    this.isWraped = false,
    this.isColored = true,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? labelStyle;
  final ValueNotifier<bool>? isLoading;
  final bool isWraped;
  final bool isColored;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isWraped ? null : double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading ?? ValueNotifier(false),
        builder: (context, loading, Widget? child) {
          return TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(padding),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 6)),
                ),
                backgroundColor: MaterialStateProperty.all(
                  !isColored ? null : color ?? Theme.of(context).primaryColor,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onPrimary,
                )),
            onPressed: loading ? null : onPressed,
            child: loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            color ?? Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                : child!,
          );
        },
        child: Text(
          label,
          style: labelStyle ??
              Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
