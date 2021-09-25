import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class SignupTermsOfServiceWidget extends StatelessWidget {
  const SignupTermsOfServiceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyles.bodyText14(context)
            .copyWith(color: context.theme.primaryTextTheme.subtitle1!.color),
        children: [
          TextSpan(text: context.locale.sign_up_description),
          TextSpan(
            text: " ${context.locale.sign_up_description_1}",
            style: TextStyles.bodyText14(context)
                .copyWith(color: context.primaryColor),
          ),
        ],
      ),
    ).hP16;
  }
}
