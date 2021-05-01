import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app_start/signup/email/signup_email_cubit.dart';
import 'package:flutter_commun_app/cubit/app_start/signup/mobile/signup_mobile_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/create_username_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/otp_Verification_page.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/widget/already_have_account_widget.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_up/widget/signup_terms_of_service_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

import '../../../../locator.dart';

class SignupWithEmailPage extends StatelessWidget {
  const SignupWithEmailPage({Key key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (context) => SignupEmailCubit(getIt<AuthRepo>()),
        child: SignupWithEmailPage(),
      ),
    );
  }

  Widget _button(BuildContext context, {String title, Color backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          await context.read<SignupEmailCubit>().signupWithEmail(context);
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

  void listener(BuildContext context, SignupEmailState state) {
    state.maybeWhen(
      orElse: () {},
      created: (credentials) {
        print("Account created");
        Navigator.push(context, CreateUserNamePage.getRoute(credentials));
      },
      response: (state, message) {
        switch (state) {
          case EVerifyEmaileState.Error:
            {
              Utility.displaySnackbar(context,
                  msg: Utility.decodeStateMessage(message));
              print(message);
              break;
            }
          default:
            print(message);
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
        ),
        body: BlocListener<SignupEmailCubit, SignupEmailState>(
          listener: listener,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    // height: context.height,
                    child: Form(
                      key: context.watch<SignupEmailCubit>().formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.locale.signUp,
                            style: TextStyles.headline36(context),
                          ),
                          SizedBox(height: 62),
                          KTextField(
                            controller: context.watch<SignupEmailCubit>().email,
                            type: FieldType.email,
                            hintText: context.locale.your_email_address,
                            backgroundColor: KColors.middle_gray_2,
                          ).pH(24),
                          SizedBox(height: 12),
                          ValueListenableBuilder<bool>(
                            valueListenable: context
                                .watch<SignupEmailCubit>()
                                .displayPasswords,
                            builder: (BuildContext context, bool value,
                                Widget child) {
                              return KTextField(
                                controller:
                                    context.watch<SignupEmailCubit>().password,
                                type: FieldType.password,
                                hintText: context.locale.create_password,
                                backgroundColor: KColors.middle_gray_2,
                                obscureText: !value,
                                suffixIcon: IconButton(
                                  icon: Icon(value
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye),
                                  onPressed: () {
                                    context
                                        .read<SignupEmailCubit>()
                                        .setDisplayPasswords = !value;
                                  },
                                ),
                              ).pH(24);
                            },
                          ),
                          SizedBox(height: 12),
                          ValueListenableBuilder<bool>(
                            valueListenable: context
                                .watch<SignupEmailCubit>()
                                .displayConfirmPasswords,
                            builder: (BuildContext context, bool value,
                                Widget child) {
                              return KTextField(
                                controller: context
                                    .watch<SignupEmailCubit>()
                                    .confirmPassword,
                                type: FieldType.password,
                                obscureText: !value,
                                hintText: context.locale.confirm_password,
                                backgroundColor: KColors.middle_gray_2,
                                suffixIcon: IconButton(
                                  icon: Icon(value
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye),
                                  onPressed: () {
                                    context
                                        .read<SignupEmailCubit>()
                                        .setDisplayConfirmPasswords = !value;
                                  },
                                ),
                              ).pH(24);
                            },
                          ),
                          SizedBox(height: 100),
                          SignupTermsOfServiceWidget().pB(16),
                          _button(context,
                                  title: context.locale.next,
                                  backgroundColor: context.primaryColor)
                              .pB(10),
                          AlreadyHaveAccountWidget()
                        ],
                      ),
                    ),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     SignupTermsOfServiceWidget().pB(16),
                //     _button(context,
                //             title: context.locale.next,
                //             backgroundColor: context.primaryColor)
                //         .pB(10),
                //     AlreadyHaveAccountWidget()
                //   ],
                // )
              ],
            ),
          ),
        ));
  }
}
