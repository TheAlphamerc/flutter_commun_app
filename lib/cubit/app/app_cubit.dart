import 'package:bloc/bloc.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'e_app_state.dart';
part 'app_state.dart';
part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  final AuthRepo authRepo;
  final ProfileRepo profileRepo;
  AppCubit(this.authRepo, this.profileRepo) : super(const AppState.initial());

  ProfileModel? user;
  // ignore: avoid_void_async
  void checkAuthentication() async {
    final response = await authRepo.getFirebaseUser();
    response.fold(
      (l) {
        emit(AppState.response(
            estate: EAppState.loggedOut,
            message: Utility.encodeStateMessage(l)));
      },
      (r) async {
        /// Fetch current user data from firebase
        fetchUser(r.uid).then((value) => null);
      },
    );
  }

  Future<void> fetchUser(String userId) async {
    final response = await profileRepo.getUserProfile(userId);
    response.fold((l) {}, (r) async {
      user = r;
      await getIt<Session>().saveUserProfile(r);
      emit(const AppState.response(
          estate: EAppState.loggedIn, message: "Autologin Sucess"));
    });
  }

  Future logout() async {
    await authRepo.logout();
    emit(const AppState.response(
        estate: EAppState.loggedOut, message: "Logged out from app"));
  }
}
