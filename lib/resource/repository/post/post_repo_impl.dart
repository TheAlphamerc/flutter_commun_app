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
  Future<Either<String, bool>> createComment(PostModel model) async {
    return postService.createComment(model);
  }

  @override
  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {required Function(FileUploadTaskResponse response) onFileUpload}) {
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
  Future<
      Either<
          String,
          Tuple2<List<PostModel>,
              QueryDocumentSnapshot<Map<String, dynamic>>>>> getPostLists(
      String userId, PageInfo pageinfo) {
    return postService.getPostLists(userId, pageinfo);
  }

  @override
  Future<
          Either<
              String,
              Tuple2<List<PostModel>,
                  QueryDocumentSnapshot<Map<String, dynamic>>>>>
      getCommunityPosts(String communityId, {required PageInfo option}) {
    return postService.getCommunityPosts(communityId, option: option);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> listenToPostChange() {
    return postService.listenPostToChange();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> listenToCommentChange(
      String parentPostId) {
    return postService.listenToCommentChange(parentPostId);
  }

  @override
  Future<Either<String, bool>> handleVote(PostModel model) {
    return postService.handleVote(model);
  }

  @override
  Future<Either<String, PostModel>> getPostDetail(String postId) async {
    return postService.getPostDetail(postId);
  }

  @override
  Future<Either<String, List<PostModel>>> getPostComments(String postId) {
    return postService.getPostComments(postId);
  }
}
