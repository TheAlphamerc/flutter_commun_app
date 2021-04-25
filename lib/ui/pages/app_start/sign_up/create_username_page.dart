import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app_start/username/username_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

import '../../../../locator.dart';

class CreateUserNamePage extends StatelessWidget {
  const CreateUserNamePage({Key key}) : super(key: key);
  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
              create: (context) => UsernameCubit(getIt<AuthRepo>()),
              child: CreateUserNamePage(),
            ));
  }

  Widget _button(BuildContext context, {String title, Color backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          context.read<UsernameCubit>().checkUserNameAvailability(context);
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

  void listener(BuildContext context, UsernameState state) {
    state.maybeWhen(
      orElse: () {},
      respose: (state, message) {
        state.when(
            elseMaybe: () {},
            alreadyExists: () {
              Utility.displaySnackbar(context, msg: "User already exists!");
            },
            available: () {
              context.read<UsernameCubit>().createUserName(context);
            },
            usernameCreated: () {
              print("Navigate to Home page");
            });
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
          padding: EdgeInsets.symmetric(horizontal: 16),
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
                  style: TextStyles.bodyText15(context).copyWith(fontSize: 17),
                ).pT(16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KTextField(
                      controller: context.watch<UsernameCubit>().username,
                      type: FieldType.name,
                      hintText: context.locale.username,
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
      ),
    );
  }
}
