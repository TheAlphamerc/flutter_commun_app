import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/model/page/page_info.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';

class FirebasePostService {
  final FirebaseFirestore firestore;

  FirebasePostService(this.firestore);

  Future<Either<String, bool>> createPost(PostModel model) async {
    final json = Utility.getMap(model.toJson(), removeNullValue: true);
    await firestore.collection(CollectionsConstants.feed).add(json);
    return Future.value(const Right(true));
  }

  Future<Either<String, bool>> createComment(PostModel model) async {
    final json = model.toJson();
    await firestore
        .collection(CollectionsConstants.comment)
        .doc(model.parentPostId)
        .collection(CollectionsConstants.statics)
        .add(json);
    return Future.value(const Right(true));
  }

  Future<Either<String, bool>> deletePost(PostModel model) async {
    try {
      if (model.parentPostId != null) {
        /// Delete if comment post
        await firestore
            .collection(CollectionsConstants.comment)
            .doc(model.parentPostId)
            .collection(CollectionsConstants.statics)
            .doc(model.id)
            .delete();
      } else {
        /// Delete if post
        await firestore
            .collection(CollectionsConstants.feed)
            .doc(model.id)
            .delete();
      }

      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<
      Either<
          String,
          Tuple2<List<PostModel>,
              QueryDocumentSnapshot<Map<String, dynamic>>>>> getPostLists(
      String userId, PageInfo pageInfo) async {
    final List<PostModel> _feedlist = [];
    QueryDocumentSnapshot<Map<String, dynamic>> lastSnapshot;
    Query<Map<String, dynamic>> query = firestore
        .collection(CollectionsConstants.feed)
        .orderBy("createdAt", descending: true);

    query = _prepareQuery(query, pageInfo);
    final querySnapshot = await query.get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = PostModel.fromJson(querySnapshot.docs[i].data());
        model = model.copyWith.call(id: querySnapshot.docs[i].id);
        final statics = await getPostStatics(model);
        statics.fold((l) => null, (r) => model = r);
        _feedlist.add(model);
      }

      lastSnapshot = querySnapshot.docs.last;

      _feedlist.sort((x, y) =>
          DateTime.parse(x.createdAt!).compareTo(DateTime.parse(y.createdAt!)));
      return Right(Tuple2(_feedlist, lastSnapshot));
    } else {
      return const Left("No Post found");
    }
  }

  Future<
          Either<
              String,
              Tuple2<List<PostModel>,
                  QueryDocumentSnapshot<Map<String, dynamic>>>>>
      getCommunityPosts(String communityId, {required PageInfo option}) async {
    final List<PostModel> _feedlist = [];
    QueryDocumentSnapshot<Map<String, dynamic>> lastSnapshot;
    var query = firestore
        .collection(CollectionsConstants.feed)
        .where("communityId", isEqualTo: communityId)
        .orderBy("createdAt", descending: true);
    query = _prepareQuery(query, option);

    final querySnapshot = await query.get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = PostModel.fromJson(querySnapshot.docs[i].data());

        model = model.copyWith.call(id: querySnapshot.docs[i].id);
        final statics = await getPostStatics(model);
        statics.fold((l) => null, (r) => model = r);
        _feedlist.add(model);
      }
      lastSnapshot = querySnapshot.docs.last;

      return Right(Tuple2(_feedlist, lastSnapshot));
    } else {
      return const Left("No Post found");
    }
  }

  Future<Either<String, PostModel>> getPostStatics(PostModel post) async {
    final querySnapshot = await firestore
        .collection(CollectionsConstants.feed)
        .doc(post.id)
        .collection(CollectionsConstants.statics)
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

  Stream<QuerySnapshot<Map<String, dynamic>>> listenPostToChange() {
    return firestore.collection(CollectionsConstants.feed).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToCommentChange(
      String parentPostId) {
    return firestore
        .collection(CollectionsConstants.comment)
        .doc(parentPostId)
        .collection(CollectionsConstants.statics)
        .snapshots();
  }

  Future<Either<String, bool>> handleVote(PostModel model) async {
    final upVote = model.upVotes;
    final downVote = model.downVotes;

    firestore
        .collection(CollectionsConstants.feed)
        .doc(model.id)
        .collection(CollectionsConstants.statics)
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
        .collection(CollectionsConstants.statics)
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
          DateTime.parse(x.createdAt!).compareTo(DateTime.parse(y.createdAt!)));
      return Right(_feedlist);
    } else {
      return const Left("No Post found");
    }
  }

  Query<Map<String, dynamic>> _prepareQuery(
      Query<Map<String, dynamic>> query, PageInfo pageInfo) {
    if (option != null) {
      if (pageInfo.lastSnapshot != null) {
        // ignore: parameter_assignments
        query = query.startAfterDocument(pageInfo.lastSnapshot!);
      }
      if (pageInfo.limit != null) {
        // ignore: parameter_assignments
        query = query.limit(pageInfo.limit!);
      }
    }

    return query;
  }
}
