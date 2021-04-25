import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../ui/widget/overlay_loader.dart';
part 'e_usename_state.dart';
part 'username_state.dart';
part 'username_cubit.freezed.dart';

class UsernameCubit extends Cubit<UsernameState> {
  final AuthRepo authRepo;
  UsernameCubit(this.authRepo) : super(UsernameState.initial()) {
    loader = CustomLoader();
    username = TextEditingController();
  }

  TextEditingController username;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomLoader loader;

  void checkUserNameAvailability(BuildContext context) async {
    loader.showLoader(context, message: "Checking");
    var response = await authRepo.checkUserNameAvailability(username.text);
    loader.hideLoader();
    response.fold((l) {
      emit(UsernameState.respose(EUsernameState.AlreadyExists,
          "Username already exists ${DateTime.now().microsecond}"));
    }, (r) {
      emit(UsernameState.respose(
          EUsernameState.Available, "Username available"));
    });
  }

  void createUserName(BuildContext context) async {
    loader.showLoader(context, message: "Creating");
    var response = await authRepo.createUserName(username.text);
    loader.hideLoader();
    response.fold((l) {
      emit(UsernameState.respose(
          EUsernameState.Error, "Username creation failed"));
    }, (r) {
      emit(UsernameState.respose(
          EUsernameState.UsernameCreated, "Username created Successfully"));
    });
  }
}
