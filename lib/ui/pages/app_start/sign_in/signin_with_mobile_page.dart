import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
import 'package:flutter_commun_app/cubit/app_start/signup/mobile/signup_mobile_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/create_username_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/otp_verification_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/widget/auth_button.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class SigninWithMobilePage extends StatelessWidget {
  const SigninWithMobilePage({Key? key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
              create: (context) => SignupMobileCubit(getIt<AuthRepo>()),
              child: const SigninWithMobilePage(),
            ));
  }

  Widget _button(BuildContext context, {required String title}) {
    return AuthButton(
      title: title,
      onPressed: () async {
        await context.read<SignupMobileCubit>().continueWithPhone(context);
      },
    );
  }

  void listener(BuildContext context, SignupMobileState state) {
    state.maybeWhen(
      orElse: () {},
      created: (credentails) {
        Navigator.pop(context);
        Utility.cprint("Navigate to Home page");
        Navigator.push(context, CreateUserNamePage.getRoute(credentails));
      },
      response: (state, message) async {
        switch (state) {
          case EVerifyMobileState.OtpSent:
            {
              Navigator.push(
                  context,
                  OTPVerificationPAge.getRoute(
                      (otp) => submitOTP(context, otp)));
              break;
            }

          /// Code [MobileAlreadyInUse] means user exists with provided mobile no.
          /// This means we can give access to app
          case EVerifyMobileState.MobileAlreadyInUse:
          case EVerifyMobileState.OtpVerified:
            {
              await Future.delayed(const Duration(milliseconds: 500));
              context.read<AppCubit>().checkAuthentication();
              break;
            }

          case EVerifyMobileState.VerficationFailed:
            {
              Utility.displaySnackbar(context,
                  msg: Utility.decodeStateMessage(message));
              Utility.cprint(message);
              break;
            }
          default:
            Utility.cprint(message);
        }
      },
    );
  }

  void submitOTP(BuildContext context, String otp) {
    context.read<SignupMobileCubit>().verifyOTP(context, otp);
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
      ),
      bottomSheet: _button(context, title: context.locale.next),
      body: BlocListener<SignupMobileCubit, SignupMobileState>(
        listener: listener,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: context.height,
                  child: Form(
                    key: context.watch<SignupMobileCubit>().formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.locale.signIn,
                          style: TextStyles.headline36(context),
                        ),
                        const SizedBox(height: 72),
                        KTextField(
                          controller: context.watch<SignupMobileCubit>().phone,
                          type: FieldType.phone,
                          hintText: context.locale.phone_no,
                          backgroundColor: KColors.light_gray,
                        ).pH(24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
