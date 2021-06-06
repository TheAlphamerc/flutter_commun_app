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
  Future<Either<String, bool>> deletePost(PostModel model) async {
    model.images.value.fold(() => null, (a) async {
      await storageService.deletePostFiles(model.images);
    });

    model.videos.value.fold(() => null, (a) async {
      await storageService.deletePostFiles(model.videos);
    });

    storageService.deletePostFiles(model.videos).then((value) => null);
    return postService.deletePost(model);
  }

  @override
  Future<Either<String, List<PostModel>>> getPostLists(String userId) {
    return postService.getPostLists(userId);
  }

  @override
  Stream<QuerySnapshot> listenPostToChange() {
    return postService.listenPostToChange();
  }

  @override
  Future<Either<String, bool>> handleVote(PostModel model) {
    return postService.handleVote(model);
  }

  @override
  Future<Either<String, PostModel>> getPostDetail(String postId) async {
    return postService.getPostDetail(postId);
  }
}
