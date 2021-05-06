part of 'profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  final FirebaseProfileService profileService;
  final FirebaseStorageService storageService;

  ProfileRepoImpl(this.profileService, this.storageService);
  @override
  Future<Either<String, bool>> updateUserProfile(ProfileModel model) {
    return profileService.updateUserProfile(model);
  }

  @override
  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {Function(FileUploadTaskResponse response) onFileUpload}) async {
    return storageService.uploadFile(file, uploadPath,
        onFileUpload: onFileUpload);
  }
}
