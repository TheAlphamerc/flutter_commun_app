import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/widget/overlay_loader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
part 'signin_email_state.dart';
part 'signin_email_cubit.freezed.dart';

class SigninEmailCubit extends Cubit<SigninEmailState>
    with SigninEmailCubitMixin {
  final AuthRepo authRepo;
  SigninEmailCubit(this.authRepo) : super(const SigninEmailState.initial()) {
    email = TextEditingController();
    password = TextEditingController();
    loader = CustomLoader();
  }

  // ignore: avoid_setters_without_getters
  set setDisplayPasswords(bool value) => displayPasswords.value = value;

  Future signinWithEmail(BuildContext context) async {
    final isValid = formKey.currentState.validate();
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
  TextEditingController email;
  TextEditingController password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> displayPasswords = ValueNotifier<bool>(false);
  CustomLoader loader;

  void dispose() {
    email.dispose();
    password.dispose();
    displayPasswords.dispose();
  }
}
