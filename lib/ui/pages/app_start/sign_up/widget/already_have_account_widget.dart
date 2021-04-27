import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class AlreadyHaveAccountWidget extends StatelessWidget {
  const AlreadyHaveAccountWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyles.headline16(context)
            .copyWith(color: context.theme.primaryTextTheme.subtitle1.color),
        children: [
          TextSpan(text: context.locale.already_have_account),
          TextSpan(
              text: " ${context.locale.signIn}",
              style: TextStyles.headline16(context)
                  .copyWith(color: context.primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("Navigate to Signin");
                }),
        ],
      ),
    ).pV(20);
  }
}
