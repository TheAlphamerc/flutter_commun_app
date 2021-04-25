import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/signup_with_mobile_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

import '../../../../locator.dart';

class ContinueWithPage extends StatelessWidget {
  const ContinueWithPage({Key key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => ContinueWithPage(),
    );
  }

  Widget _button(BuildContext context,
      {String image, String title, Color backgroundColor, Function onPressed}) {
    return OutlinedButton(
      onPressed: () {
        if (onPressed == null) {
          logger.w("$title feature is in development");
          return;
        }
        onPressed();
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? Colors.transparent),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          side: MaterialStateProperty.all(BorderSide(width: .3))),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 40,
          ).pH(25),
          Text(
            title,
            style: TextStyles.headline16(context).copyWith(
              color: backgroundColor == null
                  ? context.bodyTextColor
                  : context.onPrimary,
            ),
          )
        ],
      ),
    ).pB(16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.keyboard_arrow_left,
              color: context.bodyTextColor,
              size: 40,
            ),
          ),
        ).circular,
        title: Text(
          context.locale.signUp,
          style: TextStyles.headline36(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              _button(context,
                  image: Images.phoneIcon,
                  title: context.locale.continuwWithPhone, onPressed: () {
                Navigator.push(context, SignupWithMobilePage.getRoute());
              }),
              _button(context,
                  image: Images.googleLogo,
                  title: context.locale.continuwWithGoogle),
              _button(context,
                  image: Images.instagramLogo,
                  title: context.locale.continuwWithInstagram),
              _button(context,
                  image: Images.twitterLogo,
                  title: context.locale.continuwWithTwitter,
                  backgroundColor: KColors.twitter),
              _button(context,
                  image: Images.facebookLogo,
                  title: context.locale.continuwWithFacebook,
                  backgroundColor: KColors.facebook),
              _button(context,
                      image: Images.appleLogo,
                      title: context.locale.continuwWithApple,
                      backgroundColor: KColors.black)
                  .pB(20),

              /// Already have an account
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyles.bodyText14(context).copyWith(
                      color: context.theme.primaryTextTheme.subtitle1.color),
                  children: [
                    TextSpan(text: context.locale.sign_up_description),
                    TextSpan(
                      text: " ${context.locale.sign_up_description_1}",
                      style: TextStyles.bodyText14(context)
                          .copyWith(color: context.primaryColor),
                    ),
                  ],
                ),
              ).hP16,

              /// Sign in Text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyles.headline16(context).copyWith(
                      color: context.theme.primaryTextTheme.subtitle1.color),
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
              ).pV(20)
            ],
          ),
        ),
      ),
    );
  }
}
