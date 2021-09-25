import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.title,
    this.backgroundColor,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 20),
    this.textColor,
    this.borderSide = const BorderSide(width: .3),
  }) : super(key: key);
  final String title;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback onPressed;
  final Color? textColor;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      // stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          onPressed.call();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.primaryColor),
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
            side: MaterialStateProperty.all(borderSide)),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: textColor ?? context.onPrimary,
          ),
        ),
      ),
    );
  }
}
