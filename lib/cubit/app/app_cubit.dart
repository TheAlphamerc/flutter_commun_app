import 'package:bloc/bloc.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'e_app_state.dart';
part 'app_state.dart';
part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  final AuthRepo authRepo;
  AppCubit(this.authRepo) : super(const AppState.initial());

  // ignore: avoid_void_async
  void checkAuthentication() async {
    final response = await authRepo.getFirebaseUser();
    response.fold(
      (l) {
        emit(AppState.response(
            estate: EAppState.loggedIn,
            message: Utility.encodeStateMessage(l)));
      },
      (r) {
        emit(const AppState.response(
            estate: EAppState.loggedIn, message: "Autologin Sucess"));
      },
    );
  }

  Future logout() async {
    await authRepo.logout();
    emit(const AppState.response(
        estate: EAppState.loggedOut, message: "Logged out from app"));
  }
}
