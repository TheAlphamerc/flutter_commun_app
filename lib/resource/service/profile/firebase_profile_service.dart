import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';

class FirebaseProfileService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseProfileService(this.auth, this.firestore);

  /// Update user profile
  Future<Either<String, bool>> updateUserProfile(ProfileModel model) async {
    String? errorMessage;
    await firestore
        .collection(CollectionsConstants.profile)
        .doc(model.id)
        .update(model.toJson())
        .onError((FirebaseException error, stackTrace) {
      errorMessage = error.message;
    });
    if (errorMessage != null) {
      return Left(errorMessage!);
    }
    return Future.value(const Right(true));
  }

  Future<Either<String, ProfileModel>> getUserProfile(String userId) async {
    final ref = await firestore
        .collection(CollectionsConstants.profile)
        .doc(userId)
        .get();
    final data = ref.data();
    if (data != null) {
      final user = ProfileModel.fromJson(ref.data()!);
      return Right(user);
    } else {
      return const Left("User not found");
    }
  }
}
