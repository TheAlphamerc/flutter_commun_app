import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/widget/overlay_loader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_email_state.dart';
part 'signup_email_cubit.freezed.dart';

class SignupEmailCubit extends Cubit<SignupEmailState> {
  final AuthRepo authRepo;
  SignupEmailCubit(this.authRepo) : super(SignupEmailState.initial()) {
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    loader = CustomLoader();
  }

  TextEditingController email;
  TextEditingController password;
  TextEditingController confirmPassword;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> displayPasswords = ValueNotifier<bool>(false);
  ValueNotifier<bool> displayConfirmPasswords = ValueNotifier<bool>(false);
  CustomLoader loader;

  set setDisplayPasswords(bool value) => displayPasswords.value = value;
  set setDisplayConfirmPasswords(bool value) =>
      displayConfirmPasswords.value = value;

  Future signupWithEmail(BuildContext context) async {
    var isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    loader.showLoader(context);

    /// Tries to create a new user account with the given email address and password.
    final response = await authRepo.signupWithEmail(
        email: email.text, password: password.text);
    loader.hideLoader();
    response.fold(
        (l) => emit(SignupEmailState.response(
            EVerifyEmaileState.Error, Utility.encodeStateMessage(l))), (r) {
      emit(SignupEmailState.response(
          EVerifyEmaileState.AccountCreated, "AccountCreated"));
    });
  }

  @override
  Future<void> close() {
    email.dispose();
    password.dispose();
    displayPasswords.dispose();
    displayConfirmPasswords.dispose();
    return super.close();
  }
}
