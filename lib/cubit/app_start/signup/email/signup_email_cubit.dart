import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_email_cubit.freezed.dart';
part 'signup_email_state.dart';

class SignupEmailCubit extends Cubit<SignupEmailState>
    with SignupEmailCubitMixin {
  final AuthRepo authRepo;
  SignupEmailCubit(this.authRepo) : super(const SignupEmailState.initial()) {
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  // ignore: avoid_setters_without_getters
  set setDisplayPasswords(bool value) => displayPasswords.value = value;
  // ignore: avoid_setters_without_getters
  set setDisplayConfirmPasswords(bool value) =>
      displayConfirmPasswords.value = value;

  Future signupWithEmail(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (password.text != confirmPassword.text) {
      emit(SignupEmailState.response(
          EVerifyEmaileState.Error,
          Utility.encodeStateMessage(
              context.locale.password_confirm_password_not_mathched)));
      return;
    }

    loader.showLoader(context, message: context.locale.verifying);

    /// Tries to create a new user account with the given email address and password.
    final response = await authRepo.signupWithEmail(
        email: email.text, password: password.text);
    loader.hideLoader();
    response.fold(
        (l) => emit(SignupEmailState.response(
            EVerifyEmaileState.Error, Utility.encodeStateMessage(l))),
        (credential) {
      emit(SignupEmailState.created(credential));
    });
  }

  @override
  Future<void> close() {
    dispose();
    return super.close();
  }
}

mixin SignupEmailCubitMixin {
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> displayPasswords = ValueNotifier<bool>(false);
  ValueNotifier<bool> displayConfirmPasswords = ValueNotifier<bool>(false);

  void dispose() {
    email.dispose();
    password.dispose();
    displayPasswords.dispose();
    displayConfirmPasswords.dispose();
  }
}
