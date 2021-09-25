import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/ui/theme/index.dart';
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

  ProfileModel get user => getIt<Session>().user!;

  /// Communities joined by user
  List<CommunityModel>? get myCommunity {
    if (state.list.notNullAndEmpty) {
      if (state.list!
          .any((element) => element.myRole != MemberRole.notDefine.encode())) {
        return state.list!
            .where((element) => element.myRole != MemberRole.notDefine.encode())
            .toList();
      }
    }
    return null;
  }

  /// Communities which is not joined by user
  List<CommunityModel>? get otheCommunity {
    if (state.list.notNullAndEmpty) {
      if (state.list!
          .any((element) => element.myRole == MemberRole.notDefine.encode())) {
        return state.list!
            .where((element) => element.myRole == MemberRole.notDefine.encode())
            .toList();
      }
    }
    return null;
  }

  /// Fetch all communities list from firestore
  Future getCommunitiesList() async {
    Utility.cprint("Fetching Communities from firestore", enableLogger: true);
    final response =
        await communRepo.getCommunitiesList(getIt<Session>().user!.id!);
    response.fold(
      (l) => updateState(ECommunityFeedState.loaded,
          message:
              Utility.encodeStateMessage("Error file fetching communities")),
      (r) =>
          updateState(ECommunityFeedState.loaded, list: r, message: "sucess"),
    );

    Utility.cprint(" Communities fetching complete", enableLogger: true);
  }

  /// Jpin community
  Future joinCommunity(String communityId) async {
    final response = await communRepo.joinCommunity(
        communityId: communityId, userId: user.id!, role: MemberRole.user);
    response.fold(
        (l) => updateState(ECommunityFeedState.loaded,
            message:
                Utility.encodeStateMessage("Error file fetching communities")),
        (r) {
      var model =
          state.list!.firstWhere((element) => element.id == communityId);
      model = model.copyWith.call(myRole: MemberRole.user.encode());
      onCommunityupdate(model);
    });
  }

  /// Leave community
  Future leaveCommunity(String communityId) async {
    final response = await communRepo.leaveCommunity(
        communityId: communityId, userId: user.id!);
    response.fold(
      (l) => updateState(ECommunityFeedState.loaded,
          message:
              Utility.encodeStateMessage("Error file fetching communities")),
      (r) {
        var model =
            state.list!.firstWhere((element) => element.id == communityId);
        model = model.copyWith.call(myRole: MemberRole.notDefine.encode());
        onCommunityupdate(model);
      },
    );
  }

  void onCommunityCreated(CommunityModel model) {
    final list = state.list ?? [];
    list.insert(0, model);
    updateState(ECommunityFeedState.loaded,
        list: list, message: "New Community Added");
  }

  void onCommunityupdate(CommunityModel model) {
    final list = state.list ?? [];
    final index = list.indexWhere((element) => element.id == model.id);
    list[index] = model;
    updateState(ECommunityFeedState.loaded,
        list: list, message: "New Community Added");
  }

  void updateState(ECommunityFeedState estate,
      {String? message, List<CommunityModel>? list}) {
    emit(
      CommunityFeedState.response(estate,
          message: Utility.encodeStateMessage(message ?? ""),
          list: list ?? state.list),
    );
  }
}
