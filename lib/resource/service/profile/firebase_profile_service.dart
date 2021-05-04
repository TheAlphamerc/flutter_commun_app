import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';

class FirebaseProfileService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseProfileService(this.auth, this.firestore);

  Future<Either<String, bool>> updateUserProfile(ProfileModel model) async {
    await firestore
        .collection(CollectionsConstants.profile)
        .add(model.toJson());
    return Future.value(const Right(true));
  }
}
