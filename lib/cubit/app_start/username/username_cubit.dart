import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
part 'e_usename_state.dart';
part 'username_state.dart';
part 'username_cubit.freezed.dart';

class UsernameCubit extends Cubit<UsernameState> {
  final AuthRepo authRepo;
  final UserCredential userCredential;
  UsernameCubit({required this.authRepo, required this.userCredential})
      : super(const UsernameState.initial()) {
    username = TextEditingController();
  }

  late TextEditingController username;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future checkUserNameAvailability(BuildContext context) async {
    loader.showLoader(context, message: context.locale.checking);
    final response = await authRepo.checkUserNameAvailability(username.text);
    loader.hideLoader();
    response.fold((l) {
      emit(UsernameState.respose(EUsernameState.AlreadyExists,
          Utility.encodeStateMessage(context.locale.username_already_existed)));
    }, (r) {
      emit(UsernameState.respose(
          EUsernameState.Available, context.locale.username));
    });
  }

  Future createUserAccount(BuildContext context) async {
    final model = ProfileModel(
        createdAt:
            userCredential.user!.metadata.creationTime!.toIso8601String(),
        email: userCredential.user!.email,
        isVerified: userCredential.user!.emailVerified,
        username: username.text,
        name: userCredential.user!.displayName,
        photoURL: userCredential.user!.photoURL,
        id: userCredential.user!.uid,
        providerId: userCredential.user!.providerData.first.providerId,
        phoneNumber: userCredential.user!.phoneNumber);

    loader.showLoader(context, message: context.locale.creating);
    final response = await authRepo.createUserAccount(model);
    loader.hideLoader();
    response.fold((l) {
      emit(UsernameState.respose(
          EUsernameState.Error, context.locale.username_creation_failed));
    }, (r) {
      emit(UsernameState.created(model));
    });
  }
}
