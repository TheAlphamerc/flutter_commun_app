import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/feed/community_feed_cubit.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/ui/pages/community/detail/community_profile_page.dart';
import 'package:flutter_commun_app/ui/pages/community/widget/community_feed_app_bar.dart';
import 'package:flutter_commun_app/ui/pages/community/widget/community_tile.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/kit/alert.dart';

class CommunityFeed extends StatelessWidget {
  const CommunityFeed({Key? key}) : super(key: key);
  static Route<T> getRoute<T>() {
    return MaterialPageRoute(builder: (_) {
      return const CommunityFeed();
    });
  }

  Widget _noCommunityJoined(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
      height: context.height * .2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.locale.no_joined_community_found,
              style: TextStyles.headline16(context)),
          Text(
            context.locale.havent_joined_community,
            style: TextStyles.subtitle14(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  }

  void onCommunityCreated(BuildContext context, CommunityModel model) {
    context.read<CommunityFeedCubit>().onCommunityCreated(model);
  }

  void handleJoinButtonPressed(BuildContext context, CommunityModel model) {
    if (model.myRole == MemberRole.notDefine.encode()) {
      context.read<CommunityFeedCubit>().joinCommunity(model.id!);
    } else {
      Alert.confirmDialog(
        context,
        message: context.locale.confirm_leave_community,
        onConfirm: () {
          context.read<CommunityFeedCubit>().leaveCommunity(model.id!);
        },
      );
    }
  }

  void stateListener(BuildContext context, CommunityFeedState state) {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: KColors.background,
        appBar: CommunityFeedAppBar(
          onCommunityCreated: (model) => onCommunityCreated(context, model),
        ),
        body: BlocConsumer<CommunityFeedCubit, CommunityFeedState>(
          listener: stateListener,
          builder: (context, state) {
            return SizedBox(
              child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CommunityFeedCubit>().getCommunitiesList();
                  },
                  child: state.estate.mayBeWhen(
                    initial: () {
                      return const Center(child: CircularProgressIndicator());
                    },
                    elseMaybe: () {
                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Text(
                              context.locale.my_communties,
                              style: TextStyles.headline20(context),
                            ).p16,
                          ),
                          context
                              .watch<CommunityFeedCubit>()
                              .myCommunity
                              .value
                              .fold(
                                () => _noCommunityJoined(context),
                                (list) =>
                                    // if (state.list.notNullAndEmpty)
                                    SliverList(
                                  delegate: SliverChildListDelegate(
                                    list
                                        .map((e) => CommunityTile(
                                            model: e,
                                            onJoinButtonPressed: () =>
                                                handleJoinButtonPressed(
                                                    context, e)))
                                        .toList(),
                                  ),
                                ),
                              ),
                          SliverToBoxAdapter(
                            child: Text(
                              context.locale.trending,
                              style: TextStyles.headline20(context),
                            ).p16,
                          ),
                          context
                              .watch<CommunityFeedCubit>()
                              .otheCommunity
                              .value
                              .fold(
                                () =>
                                    const SliverToBoxAdapter(child: SizedBox()),
                                (list) => SliverList(
                                  delegate: SliverChildListDelegate(
                                    list
                                        .map((e) => CommunityTile(
                                              model: e,
                                              onJoinButtonPressed: () {
                                                context
                                                    .read<CommunityFeedCubit>()
                                                    .joinCommunity(e.id!);
                                              },
                                              onTilePressed: () {
                                                Navigator.push(
                                                  context,
                                                  CommunityProfilePage.getRoute(
                                                      community: e),
                                                );
                                              },
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                        ],
                      );
                    },
                  )),
            );
          },
        ),
      ),
    );
  }
}
