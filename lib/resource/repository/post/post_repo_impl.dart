part of 'post_repo.dart';

class PostRepoImpl extends PostRepo {
  final FirebasePostService postService;
  final FirebaseStorageService storageService;

  PostRepoImpl(this.postService, this.storageService);
  @override
  Future<Either<String, bool>> createPost(PostModel model) {
    return postService.createPost(model);
  }

  @override
  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {Function(FileUploadTaskResponse response) onFileUpload}) {
    return storageService.uploadFile(file, uploadPath,
        onFileUpload: onFileUpload);
  }

  @override
  Future<Either<String, List<PostModel>>> getPostLists(String userId) {
    return postService.getPostLists(userId);
  }
}
