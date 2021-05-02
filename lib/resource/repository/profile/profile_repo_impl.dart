part of 'profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  final FirebaseProfileService profileService;

  ProfileRepoImpl(this.profileService);
  @override
  Future<Either<String, bool>> updateUserProfile(ProfileModel model) {
    return profileService.updateUserProfile(model);
  }
}
