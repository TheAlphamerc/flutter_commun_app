import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboard_profile_state.dart';
part 'onboard_profile_cubit.freezed.dart';

class OnboardProfileCubit extends Cubit<OnboardProfileState> {
  final ProfileModel profile;
  final ProfileRepo profileRepo;
  OnboardProfileCubit(this.profile, this.profileRepo)
      : super(OnboardProfileState.initial(profile));

  Option<File> image = none();
}
