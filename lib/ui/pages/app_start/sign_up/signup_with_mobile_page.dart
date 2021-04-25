import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/signup/signup_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/otp_Verification_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class SignupWithMobilePage extends StatelessWidget {
  const SignupWithMobilePage({Key key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
              create: (context) => SignupCubit(),
              child: SignupWithMobilePage(),
            ));
  }

  Widget _button(BuildContext context, {String title, Color backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          await context.read<SignupCubit>().continueWithPhone(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.disabledColor),
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            side: MaterialStateProperty.all(BorderSide(width: .3))),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: context.onPrimary,
          ),
        ),
      ).pH(24),
    );
  }

  void listener(BuildContext context, SignupState state) {
    state.maybeWhen(
      orElse: () {},
      response: (state, message) {
        switch (state) {
          case VerifyMobileState.OtpSent:
            {
              Navigator.push(
                  context,
                  OTPVerificationPAge.getRoute(
                      (otp) => submitOTP(context, otp)));
              break;
            }

          case VerifyMobileState.OtpVerified:
            {
              Navigator.pop(context);
              print("Navigate to Home page");
              break;
            }
          case VerifyMobileState.VerficationFailed:
            {
              Utility.displaySnackbar(context, msg: message);
              print(message);
              break;
            }
          default:
            print(message);
        }
      },
    );
  }

  void submitOTP(BuildContext context, String otp) {
    context.read<SignupCubit>().verifyOTP(context, otp);
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
        body: BlocListener<SignupCubit, SignupState>(
          listener: listener,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: context.watch<SignupCubit>().formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.locale.signUp,
                    style: TextStyles.headline36(context),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KTextField(
                        controller: context.watch<SignupCubit>().phone,
                        type: FieldType.phone,
                        hintText: context.locale.phone_no,
                        backgroundColor: KColors.middle_gray_2,
                      ).pH(24),
                      SizedBox(height: 40),
                      _button(context,
                              title: context.locale.next,
                              backgroundColor: context.primaryColor)
                          .pB(40),
                    ],
                  ).extended
                ],
              ),
            ),
          ),
        ));
  }
}
