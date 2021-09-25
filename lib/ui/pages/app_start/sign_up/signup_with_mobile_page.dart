import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app_start/signup/mobile/signup_mobile_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/create_username_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/otp_verification_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/widget/already_have_account_widget.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/widget/signup_terms_of_service_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class SignupWithMobilePage extends StatelessWidget {
  const SignupWithMobilePage({Key? key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
              create: (context) => SignupMobileCubit(getIt<AuthRepo>()),
              child: const SignupWithMobilePage(),
            ));
  }

  Widget _button(BuildContext context,
      {required String title, Color? backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          await context.read<SignupMobileCubit>().continueWithPhone(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.disabledColor),
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
      ).pH(24),
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
      response: (state, message) {
        switch (state) {
          case EVerifyMobileState.OtpSent:
            {
              Navigator.push(
                  context,
                  OTPVerificationPAge.getRoute(
                      (otp) => submitOTP(context, otp)));
              break;
            }
          case EVerifyMobileState.OtpVerified:
            {
              context
                  .read<SignupMobileCubit>()
                  .checkMobileAvailability(context);
              break;
            }
          case EVerifyMobileState.MobileAlreadyInUse:
            {
              Utility.displaySnackbar(context,
                  msg: Utility.decodeStateMessage(message));
              Utility.cprint(message);
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
                            context.locale.signUp,
                            style: TextStyles.headline36(context),
                          ),
                          const SizedBox(height: 72),
                          KTextField(
                            controller:
                                context.watch<SignupMobileCubit>().phone,
                            type: FieldType.phone,
                            hintText: context.locale.phone_no,
                            backgroundColor: KColors.light_gray,
                          ).pH(24),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SignupTermsOfServiceWidget().pB(16),
                    _button(context,
                            title: context.locale.next,
                            backgroundColor: context.primaryColor)
                        .pB(10),
                    const AlreadyHaveAccountWidget()
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
