import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';

class FirebasePostService {
  final FirebaseFirestore firestore;

  FirebasePostService(this.firestore);

  Future<Either<String, bool>> createPost(PostModel model) async {
    final json = model.toJson();
    await firestore.collection(CollectionsConstants.feed).add(json);
    return Future.value(const Right(true));
  }

  Future<Either<String, bool>> createComment(PostModel model) async {
    final json = model.toJson();
    await firestore
        .collection(CollectionsConstants.comment)
        .doc(model.parentPostId)
        .collection(CollectionsConstants.postStatics)
        .add(json);
    return Future.value(const Right(true));
  }

  Future<Either<String, bool>> deletePost(PostModel model) async {
    try {
      await firestore
          .collection(CollectionsConstants.feed)
          .doc(model.id)
          .delete();
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<PostModel>>> getPostLists(String userId) async {
    final List<PostModel> _feedlist = [];
    final querySnapshot =
        await firestore.collection(CollectionsConstants.feed).get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = PostModel.fromJson(querySnapshot.docs[i].data());
        model = model.copyWith.call(id: querySnapshot.docs[i].id);
        final statics = await getPostStatics(model);
        statics.fold((l) => null, (r) => model = r);
        _feedlist.add(model);
      }

      /// Sort Tweet by time
      /// It helps to display newest Tweet first.
      _feedlist.sort((x, y) =>
          DateTime.parse(x.createdAt).compareTo(DateTime.parse(y.createdAt)));
      return Right(_feedlist);
    } else {
      return const Left("No Post found");
    }
  }

  Future<Either<String, PostModel>> getPostStatics(PostModel post) async {
    final querySnapshot = await firestore
        .collection(CollectionsConstants.feed)
        .doc(post.id)
        .collection(CollectionsConstants.postStatics)
        .get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        final map = querySnapshot.docs[i].data();

        if (map.keys.contains("downVote")) {
          final share = map["downVote"].cast<String>();
          final voteList = cast<List<String>>(share);
          // ignore: parameter_assignments
          post = post.copyWith.call(downVotes: voteList);
        }
        if (map.keys.contains("upVote")) {
          final share = map["upVote"].cast<String>();
          final voteList = cast<List<String>>(share);
          // ignore: parameter_assignments
          post = post.copyWith.call(upVotes: voteList);
        }
        if (map.keys.contains("share")) {
          final share = map["share"].cast<String>();
          final sharesList = cast<List<String>>(share);
          // ignore: parameter_assignments
          post = post.copyWith.call(shareList: sharesList);
        }
      }

      return Right(post);
    } else {
      return const Left("No statics found");
    }
  }

  Stream<QuerySnapshot> listenPostToChange() {
    return firestore.collection(CollectionsConstants.feed).snapshots();
  }

  Future<Either<String, bool>> handleVote(PostModel model) async {
    final upVote = model.upVotes;
    final downVote = model.downVotes;

    firestore
        .collection(CollectionsConstants.feed)
        .doc(model.id)
        .collection(CollectionsConstants.postStatics)
        .doc(CollectionsConstants.postVote)
        .set({"upVote": upVote, "downVote": downVote});
    return Future.value(const Right(true));
  }

  Future<Either<String, PostModel>> getPostDetail(String postId) async {
    final querySnapshot =
        await firestore.collection(CollectionsConstants.feed).doc(postId).get();
    final map = querySnapshot.data();
    if (map != null) {
      var model = PostModel.fromJson(map);
      model = model.copyWith.call(id: querySnapshot.id);
      final statics = await getPostStatics(model);
      statics.fold((l) => null, (r) => model = r);

      return Right(model);
    } else {
      return const Left("Post not found");
    }
  }

  Future<Either<String, List<PostModel>>> getPostComments(String postId) async {
    final List<PostModel> _feedlist = [];
    final querySnapshot = await firestore
        .collection(CollectionsConstants.comment)
        .doc(postId)
        .collection(CollectionsConstants.postStatics)
        .get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = PostModel.fromJson(querySnapshot.docs[i].data());
        model = model.copyWith.call(id: querySnapshot.docs[i].id);
        final statics = await getPostStatics(model);
        statics.fold((l) => null, (r) => model = r);
        _feedlist.add(model);
      }

      /// Sort Tweet by time
      /// It helps to display newest Tweet first.
      _feedlist.sort((x, y) =>
          DateTime.parse(x.createdAt).compareTo(DateTime.parse(y.createdAt)));
      return Right(_feedlist);
    } else {
      return const Left("No Post found");
    }
  }
}
