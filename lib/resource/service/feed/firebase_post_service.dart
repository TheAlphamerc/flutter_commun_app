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

  Future<Either<String, List<PostModel>>> getPostLists(String userId) async {
    final List<PostModel> _feedlist = [];
    final querySnapshot =
        await firestore.collection(CollectionsConstants.feed).get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = PostModel.fromJson(querySnapshot.docs[i].data());
        model = model.copyWith.call(id: querySnapshot.docs[i].id);
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
