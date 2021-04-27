import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/ui/widget/overlay_loader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_signup_state.dart';
part 'social_signup_cubit.freezed.dart';

class SocialSignupCubit extends Cubit<SocialSignupState> {
  final AuthRepo authRepo;
  SocialSignupCubit(this.authRepo) : super(SocialSignupState.initial()) {
    loader = CustomLoader();
  }
  CustomLoader loader;
  Future signupWithGoogle(BuildContext context) async {
    loader.showLoader(
      context,
    );
    final response = await authRepo.signupWithGoogle();
    loader.hideLoader();
    response.fold(
        (l) => emit(SocialSignupState.response(
            ESocialSignupState.Error, Utility.encodeStateMessage(l))),
        (r) => emit(SocialSignupState.response(
            ESocialSignupState.AccountCreated, "AccountCreated!!")));
  }
}
