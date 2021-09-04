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
    final json = model.toJson();
    final doc =
        await firestore.collection(CollectionsConstants.community).add(json);
    joinCommunity(
        communityId: doc.id, role: MemberRole.admin, userId: model.createdBy);
    return Future.value(Right(doc));
  }

  Future<Either<String, bool>> updateCommunity(CommunityModel model) async {
    final json = model.toJson();
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

  Future<Either<String, CommunityModel>> getCommunityById(
      String id, String userId) async {
    final docSnapshot = await firestore
        .collection(CollectionsConstants.community)
        .doc(id)
        .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      var community = CommunityModel.fromJson(data);
      final role = await getMyRole(community.id, userId);
      community = community.copyWith.call(myRole: role);

      return Right(community);
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
    /// Add user to the commmunity member list
    await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .doc(userId)
        .set({
      "user": userId,
      "role": role.encode(),
      "joinedAt": DateTime.now().toIso8601String()
    });

    /// Add community id to user communities list
    await firestore
        .collection(CollectionsConstants.profile)
        .doc(userId)
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .set({
      "communityId": communityId,
      "role": role.encode(),
      "joinedAt": DateTime.now().toIso8601String()
    });

    /// Increase community member count by 1
    final community = await getCommunityById(communityId, userId);
    community.fold(
      (l) => null,
      (model) =>
          updateCommunity(model.copyWith(membersCount: model.membersCount + 1)),
    );

    return const Right(true);
  }

  Future<Either<String, bool>> leaveCommunity(
      {String communityId, String userId}) async {
    /// Remove user from the commmunity member list
    await firestore
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .collection(CollectionsConstants.statics)
        .doc(userId)
        .delete();

    /// Remove community id from user communities list
    await firestore
        .collection(CollectionsConstants.profile)
        .doc(userId)
        .collection(CollectionsConstants.community)
        .doc(communityId)
        .delete();

    /// Decrease community members count by 1
    final community = await getCommunityById(communityId, userId);
    community.fold(
      (l) => null,
      (model) =>
          updateCommunity(model.copyWith(membersCount: model.membersCount - 1)),
    );

    return const Right(true);
  }
}
