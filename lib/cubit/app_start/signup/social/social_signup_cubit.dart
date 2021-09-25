import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_signup_cubit.freezed.dart';
part 'social_signup_state.dart';

class SocialSignupCubit extends Cubit<SocialSignupState> {
  final AuthRepo authRepo;
  SocialSignupCubit(this.authRepo) : super(const SocialSignupState.initial());
  UserCredential? userCredential;

  Future signupWithGoogle(BuildContext context) async {
    loader.showLoader(context);
    final response = await authRepo.signupWithGoogle();
    loader.hideLoader();
    response.fold(
        (l) => emit(SocialSignupState.response(
            ESocialSignupState.Error, Utility.encodeStateMessage(l))), (r) {
      userCredential = r;
      emit(SocialSignupState.response(
          ESocialSignupState.CheckingEmail, context.locale.checking));
    });
  }

  Future checkEmailAvailability(BuildContext context) async {
    loader.showLoader(context, message: context.locale.verifying);
    final response =
        await authRepo.checkEmailAvailability(userCredential!.user!.email!);
    loader.hideLoader();
    response.fold(
        (l) => emit(SocialSignupState.response(
            ESocialSignupState.AccountAlreadyExists,
            Utility.encodeStateMessage("Account Already exists"))),
        (r) => emit(SocialSignupState.created(userCredential!)));
  }
}
