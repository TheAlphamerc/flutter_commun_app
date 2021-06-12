import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/resource/service/community/firebase_community_service.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/resource/service/storage/firebase_storage_service.dart';

part 'community_feed_repo_impl.dart';

abstract class CommunityFeedRepo {
  Future<Either<String, DocumentReference>> createCommunity(
      CommunityModel model);
  Future<Either<String, bool>> updateCommunity(CommunityModel model);
  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {Function(FileUploadTaskResponse response) onFileUpload});
  Future<Either<String, List<CommunityModel>>> getCommunitiesList(
      String userId);
  Future<Either<String, bool>> joinCommunity(
      {String communityId, String userId, MemberRole role});

  Future<Either<String, bool>> leaveCommunity(
      {String communityId, String userId});
}
