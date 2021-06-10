import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/feed/community_feed_cubit.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/ui/pages/community/widget/community_feed_app_bar.dart';
import 'package:flutter_commun_app/ui/pages/community/widget/community_tile.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommunityFeed extends StatelessWidget {
  const CommunityFeed({Key key}) : super(key: key);
  static Route<T> getRoute<T>() {
    return MaterialPageRoute(builder: (_) {
      return const CommunityFeed();
    });
  }

  Widget _communityList(List<CommunityModel> list) {
    return Container();
  }

  void stateListener(BuildContext context, CommunityFeedState state) {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CommunityFeedAppBar(),
        body: BlocConsumer<CommunityFeedCubit, CommunityFeedState>(
          listener: stateListener,
          builder: (context, state) {
            return SizedBox(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CommunityFeedCubit>().getCommunitiesList();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Text(
                        "My Communities",
                        style: TextStyles.headline20(context),
                      ).p16,
                    ),
                    if (state.list.notNullAndEmpty)
                      SliverList(
                        delegate: SliverChildListDelegate(
                          state.list
                              .map((e) => CommunityTile(
                                  model: e,
                                  onJoinButtonPressed: () {
                                    context
                                        .read<CommunityFeedCubit>()
                                        .joinCommunity(e.id);
                                  }))
                              .toList(),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
