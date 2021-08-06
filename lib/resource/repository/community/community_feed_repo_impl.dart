part of 'community_feed_repo.dart';

class CommunityFeedRepoImpl implements CommunityFeedRepo {
  final FirebaseCommunityService communService;
  final FirebaseStorageService storageService;

  CommunityFeedRepoImpl(this.communService, this.storageService);
  @override
  Future<Either<String, DocumentReference>> createCommunity(
      CommunityModel model) {
    return communService.createCommunity(model);
  }

  @override
  Future<Either<String, bool>> updateCommunity(CommunityModel model) {
    return communService.updateCommunity(model);
  }

  @override
  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {Function(FileUploadTaskResponse response) onFileUpload}) {
    return storageService.uploadFile(file, uploadPath,
        onFileUpload: onFileUpload);
  }

  @override
  Future<Either<String, List<CommunityModel>>> getCommunitiesList(
      String userId) {
    return communService.getCommunitiesList(userId);
  }

  @override
  Future<Either<String, CommunityModel>> getCommunityById(String id) {
    final userId = getIt<Session>().user.id;
    return communService.getCommunityById(id, userId);
  }

  @override
  Future<Either<String, bool>> joinCommunity(
      {String communityId, String userId, MemberRole role}) async {
    return communService.joinCommunity(
        communityId: communityId, userId: userId, role: role);
  }

  @override
  Future<Either<String, bool>> leaveCommunity(
      {String communityId, String userId}) {
    return communService.leaveCommunity(
        communityId: communityId, userId: userId);
  }
}
