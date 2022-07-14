import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_upload_task_response.freezed.dart';

@freezed
abstract class FileUploadTaskResponse with _$FileUploadTaskResponse {
  const factory FileUploadTaskResponse.snapshot(TaskSnapshot snapshot) =
      _Snapshot;
  const factory FileUploadTaskResponse.onError(String errorCode) = _OnError;
}
