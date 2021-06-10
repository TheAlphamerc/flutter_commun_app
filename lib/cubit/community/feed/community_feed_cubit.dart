import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_feed_cubit.freezed.dart';
part 'community_feed_state.dart';
part 'e_community_feed_state.dart';

class CommunityFeedCubit extends Cubit<CommunityFeedState> {
  final CommunityFeedRepo communRepo;
  CommunityFeedCubit(this.communRepo)
      : super(const CommunityFeedState.response(ECommunityFeedState.initial)) {
    getCommunitiesList().then((value) => null);
  }

  ProfileModel get user => getIt<Session>().user;

  Future getCommunitiesList() async {
    final response = await communRepo.getCommunitiesList();
    response.fold(
      (l) => updateState(ECommunityFeedState.loaded,
          message:
              Utility.encodeStateMessage("Error file fetching communities")),
      (r) =>
          updateState(ECommunityFeedState.loaded, list: r, message: "sucess"),
    );
  }

  Future joinCommunity(String communityId) async {
    final response = await communRepo.joinCommunity(communityId, user.id);
    response.fold(
      (l) => updateState(ECommunityFeedState.loaded,
          message:
              Utility.encodeStateMessage("Error file fetching communities")),
      (r) => updateState(ECommunityFeedState.communityJoined,
          message: "Community Joined"),
    );
  }

  void updateState(ECommunityFeedState estate,
      {String message, List<CommunityModel> list}) {
    emit(
      CommunityFeedState.response(estate,
          message: Utility.encodeStateMessage(message),
          list: list ?? state.list),
    );
  }
}
