import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app_start/username/username_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/pages/app_start/onboard/onboard_user_profile.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

import '../../../../locator.dart';

class CreateUserNamePage extends StatelessWidget {
  const CreateUserNamePage({Key? key}) : super(key: key);
  static MaterialPageRoute getRoute(UserCredential userCredential) {
    return MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (context) => UsernameCubit(
            authRepo: getIt<AuthRepo>(), userCredential: userCredential),
        child: const CreateUserNamePage(),
      ),
    );
  }

  Widget _button(BuildContext context,
      {required String title, Color? backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          context.read<UsernameCubit>().checkUserNameAvailability(context);
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

  void listener(BuildContext context, UsernameState state) {
    state.maybeWhen(
      orElse: () {},
      created: (profile) {
        /// Permform action on the basis of login type
        logger.i("Account created:successfully!!. Navigate to Home page");
        Navigator.pushReplacement(
            context, OnBoardUserProfilePage.getRoute(profile));
      },
      respose: (state, message) {
        state.when(
          elseMaybe: () {},
          alreadyExists: () {
            Utility.displaySnackbar(context,
                msg: Utility.decodeStateMessage(message));
          },
          available: () {
            context.read<UsernameCubit>().createUserAccount(context);
          },
          accountCreated: () {
            Utility.cprint("Account created");
          },
        );
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
      body: BlocListener<UsernameCubit, UsernameState>(
        listener: listener,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: context.height,
                  child: Form(
                    key: context.watch<UsernameCubit>().formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.locale.signUp,
                          style: TextStyles.headline36(context),
                        ),
                        Text(
                          context.locale.create_your_username,
                          style: TextStyles.bodyText15(context)
                              .copyWith(fontSize: 17),
                        ).pT(19),
                        Column(
                          children: [
                            const SizedBox(height: 72),
                            KTextField(
                              controller:
                                  context.watch<UsernameCubit>().username,
                              type: FieldType.name,
                              hintText: context.locale.username,
                              backgroundColor: KColors.light_gray,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp("[^A-Za-z0-9]"))
                              ],
                            ).pH(24),
                            const SizedBox(height: 40),
                          ],
                        ).extended
                      ],
                    ),
                  ),
                ),
              ),
              _button(context,
                      title: context.locale.next,
                      backgroundColor: context.primaryColor)
                  .alignBottomCenter
                  .pB(40),
            ],
          ),
        ),
      ),
    );
  }
}
