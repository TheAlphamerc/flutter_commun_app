import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/sign_up_with_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class DontHaveAccountWidget extends StatelessWidget {
  const DontHaveAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyles.headline16(context)
            .copyWith(color: context.theme.primaryTextTheme.subtitle1!.color),
        children: [
          const TextSpan(text: "Don't have an account?"),
          TextSpan(
              text: " ${context.locale.signUp}",
              style: TextStyles.headline16(context)
                  .copyWith(color: context.primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Utility.cprint("Navigate to Signin");
                  Navigator.push(context, SignUpWithPage.getRoute());
                }),
        ],
      ),
    ).pV(20);
  }
}
