import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';

class FirebaseCommunityService {
  final FirebaseFirestore firestore;

  FirebaseCommunityService(this.firestore);

  Future<Either<String, DocumentReference>> createCommunity(
      CommunityModel model) async {
    final json = model.getJson;
    final doc =
        await firestore.collection(CollectionsConstants.community).add(json);
    return Future.value(Right(doc));
  }

  Future<Either<String, bool>> updateCommunity(CommunityModel model) async {
    final json = model.getJson;
    firestore
        .collection(CollectionsConstants.community)
        .doc(model.id)
        .update(json);
    return Future.value(const Right(true));
  }

  Future<Either<String, List<CommunityModel>>> getCommunitiesList() async {
    final List<CommunityModel> _feedlist = [];
    final querySnapshot =
        await firestore.collection(CollectionsConstants.community).get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = CommunityModel.fromJson(querySnapshot.docs[i].data());
        model = model.copyWith.call(id: querySnapshot.docs[i].id);
        // final statics = await getPostStatics(model);
        // statics.fold((l) => null, (r) => model = r);
        _feedlist.add(model);
      }

      /// Sort Tweet by time
      /// It helps to display newest Tweet first.
      // _feedlist.sort((x, y) =>
      //     DateTime.parse(x.createdAt).compareTo(DateTime.parse(y.createdAt)));
      return Right(_feedlist);
    } else {
      return const Left("No Community found");
    }
  }

  Future<Either<String, bool>> joinCommunity(
      String communityId, String userId) async {
    await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .add({"user": userId});
    return const Right(true);
  }
}
