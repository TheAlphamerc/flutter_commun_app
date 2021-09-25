import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_email_cubit.freezed.dart';
part 'signin_email_state.dart';

class SigninEmailCubit extends Cubit<SigninEmailState>
    with SigninEmailCubitMixin {
  final AuthRepo authRepo;
  SigninEmailCubit(this.authRepo) : super(const SigninEmailState.initial()) {
    email = TextEditingController();
    password = TextEditingController();
  }

  // ignore: avoid_setters_without_getters
  set setDisplayPasswords(bool value) => displayPasswords.value = value;

  Future signinWithEmail(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    loader.showLoader(context, message: context.locale.verifying);

    /// Attempt to login with the given email address and password.
    final response = await authRepo.signInWithEmail(
        email: email.text, password: password.text);
    loader.hideLoader();
    response.fold(
        (l) => emit(SigninEmailState.response(
            ESigninEmailState.Error, Utility.encodeStateMessage(l))),
        (credential) {
      emit(SigninEmailState.verfied(credential));
    });
  }

  @override
  Future<void> close() {
    dispose();
    return super.close();
  }
}

mixin SigninEmailCubitMixin {
  late TextEditingController email;
  late TextEditingController password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> displayPasswords = ValueNotifier<bool>(false);

  void dispose() {
    email.dispose();
    password.dispose();
    displayPasswords.dispose();
  }
}
