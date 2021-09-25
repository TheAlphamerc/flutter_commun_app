import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
import 'package:flutter_commun_app/cubit/app_start/Signin/email/signin_email_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/pages/app_start/widget/auth_button.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class SignInWithEmailPage extends StatelessWidget {
  const SignInWithEmailPage({Key? key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (context) => SigninEmailCubit(getIt<AuthRepo>()),
        child: const SignInWithEmailPage(),
      ),
    );
  }

  Widget _button(BuildContext context, {required String title}) {
    return AuthButton(
      title: title,
      onPressed: () async {
        await context.read<SigninEmailCubit>().signinWithEmail(context);
      },
    );
  }

  void listener(BuildContext context, SigninEmailState state) {
    state.maybeWhen(
      orElse: () {},
      verfied: (credentials) async {
        Utility.cprint("Account verfied");
        await Future.delayed(const Duration(milliseconds: 500));
        context.read<AppCubit>().checkAuthentication();
      },
      response: (state, message) {
        switch (state) {
          case ESigninEmailState.Error:
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
      body: BlocListener<SigninEmailCubit, SigninEmailState>(
        listener: listener,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  child: Form(
                    key: context.watch<SigninEmailCubit>().formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.locale.signIn,
                          style: TextStyles.headline36(context),
                        ),
                        const SizedBox(height: 62),
                        KTextField(
                          controller: context.watch<SigninEmailCubit>().email,
                          type: FieldType.email,
                          hintText: context.locale.your_email_address,
                          backgroundColor: KColors.light_gray,
                        ).pH(24),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<bool>(
                          valueListenable: context
                              .watch<SigninEmailCubit>()
                              .displayPasswords,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return KTextField(
                              controller:
                                  context.watch<SigninEmailCubit>().password,
                              type: FieldType.password,
                              hintText: context.locale.password,
                              backgroundColor: KColors.light_gray,
                              obscureText: !value,
                              suffixIcon: IconButton(
                                icon: Icon(value
                                    ? Icons.visibility_off
                                    : Icons.remove_red_eye),
                                onPressed: () {
                                  context
                                      .read<SigninEmailCubit>()
                                      .setDisplayPasswords = !value;
                                },
                              ),
                            ).pH(24);
                          },
                        ),
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
