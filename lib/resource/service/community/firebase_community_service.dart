import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';

class FirebaseCommunityService {
  final FirebaseFirestore firestore;

  FirebaseCommunityService(this.firestore);

  Future<Either<String, DocumentReference>> createCommunity(
      CommunityModel model) async {
    final json = model.getJson;
    final doc =
        await firestore.collection(CollectionsConstants.community).add(json);
    joinCommunity(
        communityId: doc.id, role: MemberRole.admin, userId: model.createdBy);
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

  Future<Either<String, List<CommunityModel>>> getCommunitiesList(
      String userId) async {
    final List<CommunityModel> _feedlist = [];
    final querySnapshot =
        await firestore.collection(CollectionsConstants.community).get();
    final data = querySnapshot.docs;
    if (data != null && data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var model = CommunityModel.fromJson(querySnapshot.docs[i].data());
        model = model.copyWith.call(id: querySnapshot.docs[i].id);
        final role = await getMyRole(model.id, userId);
        model = model.copyWith.call(myRole: role);
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

  Future<String> getMyRole(String communityId, String userId) async {
    final querySnapshot = await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .where("user", isEqualTo: userId)
        .get()
        .onError((error, stackTrace) {
      Utility.cprint("[GetMyRole]", error: error, stackTrace: stackTrace);
      return null;
    });
    if (querySnapshot != null) {
      final doc = querySnapshot.docs;
      if (doc != null && doc.isNotEmpty) {
        final role = doc.first.data();
        return role["role"] as String;
      }
    }
    return "";
  }

  Future<Either<String, bool>> joinCommunity(
      {String communityId, String userId, MemberRole role}) async {
    await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .add({"user": userId, "role": role.encode()});
    return const Right(true);
  }

  Future<Either<String, bool>> leaveCommunity(
      {String communityId, String userId}) async {
    final snapshot = await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .where("user", isEqualTo: userId)
        .get();
    final docId = snapshot.docs.first.id;

    await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .doc(docId)
        .delete();
    return const Right(true);
  }
}
