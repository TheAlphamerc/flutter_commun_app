import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';

class FirebaseStorageService {
  final firebase_storage.FirebaseStorage storage;

  FirebaseStorageService(this.storage);

  Future<Either<String, String>> uploadFile(File file, String uploadPath,
      {required Function(FileUploadTaskResponse response) onFileUpload}) async {
    // We can still optionally use the Future alongside the stream.
    try {
      final firebase_storage.Reference ref = storage.ref(uploadPath);
      final firebase_storage.UploadTask task = ref.putFile(file);

      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        onFileUpload(FileUploadTaskResponse.snapshot(snapshot));
      }, onError: (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        Utility.cprint("onError", error: task.snapshot);

        if (e.code == 'permission-denied') {
          Utility.cprint(
              'User does not have permission to upload to this reference.');
          onFileUpload(
              const FileUploadTaskResponse.onError("permission-denied"));
        }
      });
      await task;
      final filePath = await ref.getDownloadURL();
      Utility.cprint('Upload complete.');
      return Right(filePath);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        Utility.cprint(
            'User does not have permission to upload to this reference.');
      }
      onFileUpload(FileUploadTaskResponse.onError(e.code));
      return Right(e.code);
    }
  }

  Future deletePostFiles(List<String>? list) async {
    if (list.notNullAndEmpty) {
      for (final path in list!) {
        final photoRef = storage.refFromURL(path);
        Utility.cprint('[Path]$path');
        try {
          await photoRef.delete();
        } catch (e) {
          Utility.cprint('[deletePostFiles]', error: e);
        }
      }
    }
  }
}
