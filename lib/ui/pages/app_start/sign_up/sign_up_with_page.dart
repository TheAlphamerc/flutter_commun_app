import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/signup_with_email_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/signup_with_mobile_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/widget/signup_terms_of_service_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class SignUpWithPage extends StatelessWidget {
  const SignUpWithPage({Key? key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const SignUpWithPage(),
    );
  }

  Widget _button(BuildContext context,
      {required String image,
      required String title,
      Color? backgroundColor,
      required Function onPressed}) {
    return OutlinedButton(
      onPressed: () {
        // if (onPressed == null) {
        //   logger.w("$title feature is in development");
        //   return;
        // }
        onPressed();
      },
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? Colors.transparent),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 10)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          side: MaterialStateProperty.all(const BorderSide(width: .3))),
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
        height: context.height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            _button(context,
                image: Images.phoneIcon,
                title: "Create Account with Phone", onPressed: () {
              Navigator.push(context, SignupWithMobilePage.getRoute());
            }),
            _button(context,
                image: Images.emailIconBlack,
                title: "Create Account with Email", onPressed: () {
              Navigator.push(context, SignupWithEmailPage.getRoute());
            }),
            const Spacer(),

            /// Already have an account
            const SignupTermsOfServiceWidget(),
          ],
        ),
      ),
    );
  }
}
