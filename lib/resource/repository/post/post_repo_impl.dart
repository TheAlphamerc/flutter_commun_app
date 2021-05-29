part of 'post_repo.dart';

class PostRepoImpl extends PostRepo {
  final FirebasePostService postService;

  PostRepoImpl(this.postService);
  @override
  Future<Either<String, bool>> createPost(PostModel model) {
    return postService.createPost(model);
  }
}
