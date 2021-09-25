import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/service/profile/firebase_profile_service.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/resource/service/storage/firebase_storage_service.dart';

part 'profile_repo_impl.dart';

abstract class ProfileRepo {
  Future<Either<String, bool>> updateUserProfile(ProfileModel model);
  Future<Either<String, ProfileModel>> getUserProfile(String userId);
  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {required void Function(FileUploadTaskResponse response) onFileUpload});
}
