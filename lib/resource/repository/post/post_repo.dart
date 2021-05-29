import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/service/feed/firebase_post_service.dart';

part 'post_repo_impl.dart';

abstract class PostRepo {
  Future<Either<String, bool>> createPost(PostModel model);
}
