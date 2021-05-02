import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/service/profile/firebase_profile_service.dart';

part 'profile_repo_impl.dart';

abstract class ProfileRepo {
  Future<Either<String, bool>> updateUserProfile(ProfileModel model);
}
