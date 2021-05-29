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
}
