import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
import 'package:flutter_commun_app/cubit/app_start/signup/social/social_signup_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_in/signin_with_email_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_in/signin_with_mobile_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/create_username_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/widget/dont_have_account_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

import '../../../../locator.dart';

class ContinueWithPage extends StatelessWidget {
  const ContinueWithPage({Key? key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
              create: (context) => SocialSignupCubit(getIt<AuthRepo>()),
              child: const ContinueWithPage(),
            ));
  }

  Widget _button(BuildContext context,
      {required String image,
      required String title,
      Color? backgroundColor,
      Function? onPressed}) {
    return OutlinedButton(
      onPressed: () {
        if (onPressed == null) {
          logger.w("$title feature is in development");
          Utility.displaySnackbar(context, msg: "Feature under development");
          return;
        }
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
          Image.asset(image, height: 40).pH(25),
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

  void listener(BuildContext context, SocialSignupState state) {
    state.maybeWhen(
      orElse: () {},
      created: (credentails) {
        Navigator.push(context, CreateUserNamePage.getRoute(credentails));
      },
      response: (state, message) async {
        switch (state) {
          case ESocialSignupState.Error:
            {
              Utility.displaySnackbar(context,
                  msg: Utility.decodeStateMessage(message));
            }
            break;
          case ESocialSignupState.CheckingEmail:
            {
              context.read<SocialSignupCubit>().checkEmailAvailability(context);
            }
            break;
          case ESocialSignupState.AccountAlreadyExists:
            {
              await Future.delayed(const Duration(milliseconds: 500));
              context.read<AppCubit>().checkAuthentication();
            }
            break;
          default:
        }
      },
    );
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
          context.locale.signIn,
          style: TextStyles.headline36(context),
        ),
      ),
      body: BlocListener<SocialSignupCubit, SocialSignupState>(
        listener: listener,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _button(context,
                    image: Images.phoneIcon,
                    title: "Login with Phone", onPressed: () {
                  Navigator.push(context, SigninWithMobilePage.getRoute());
                }),
                _button(context,
                    image: Images.emailIconBlack,
                    title: "Login With Email", onPressed: () {
                  Navigator.push(context, SignInWithEmailPage.getRoute());
                }),
                _button(context,
                    image: Images.googleLogo,
                    title: context.locale.continuwWithGoogle, onPressed: () {
                  context.read<SocialSignupCubit>().signupWithGoogle(context);
                }),
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

                /// Sign in Text
                const DontHaveAccountWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
