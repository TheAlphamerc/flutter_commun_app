import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.dart';
part 'create_post_cubit.freezed.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepo postRepo;
  CreatePostCubit({this.postRepo}) : super(const CreatePostState.initial()) {
    getProfile().then((value) => null);
    description = TextEditingController();
  }

  TextEditingController description;
  ProfileModel user;

  Future getProfile() async {
    user = await getIt<Session>().getUserProfile();
  }

  Future<void> createPost(BuildContext context) async {
    if (description.text.isEmpty) {
      return;
    }
    var us = user;
    final model = PostModel(
      description: description.text,
      createdBy: user.id,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
    emit(const CreatePostState.response(estate: ECreatePostState.saving));
    final response = await postRepo.createPost(model);
    response.fold(
      (l) {
        Utility.cprint(l ?? "Operation failed");
        emit(CreatePostState.response(
            estate: ECreatePostState.eror,
            message: l ?? "Post created failed"));
      },
      (r) {
        emit(const CreatePostState.response(
            estate: ECreatePostState.saved,
            message: "Post created successfully"));
      },
    );
  }

  @override
  Future<void> close() {
    description.dispose();
    return super.close();
  }
}
