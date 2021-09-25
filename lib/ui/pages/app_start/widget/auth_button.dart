import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.title,
    this.backgroundColor,
    required this.onPressed,
    this.margin = const EdgeInsets.fromLTRB(30, 0, 30, 20),
  }) : super(key: key);
  final String title;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      margin: margin,
      child: TextButton(
        onPressed: () async {
          if (onPressed != null) {
            FocusManager.instance.primaryFocus!.unfocus();
            onPressed.call();
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.primaryColor),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            side: MaterialStateProperty.all(const BorderSide(width: .3))),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: context.onPrimary,
          ),
        ),
      ),
    );
  }
}
