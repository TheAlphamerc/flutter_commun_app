import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/cubit/community/profile/community_profile_cubit.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';
import 'package:flutter_commun_app/ui/widget/image_viewer.dart';

class CommunityProfilePage extends StatelessWidget {
  const CommunityProfilePage({Key key}) : super(key: key);

  static Route<T> getRoute<T>({CommunityModel community, String communityId}) {
    assert(community != null || communityId != null);
    return MaterialPageRoute(builder: (_) {
      return BlocProvider(
        create: (context) => CommunityProfileCubit(
          getIt<CommunityFeedRepo>(),
          getIt<PostRepo>(),
          community: community,
          communityId: communityId,
        ),
        child: const CommunityProfilePage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: SizedBox(
        child: CustomScrollView(
          slivers: [
            /// Community banner image
            BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
              builder: (context, state) {
                return state.estate.mayBeWhen(
                  elseMaybe: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loaded: () => SliverAppBar(
                    expandedHeight: context.height * .23,
                    flexibleSpace: FlexibleSpaceBar(
                      background: !state.community.banner.isNotNullEmpty
                          ? Container(
                              color: context.theme.cardColor,
                            )
                          : CacheImage(
                              path: state.community.banner,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                );
              },
            ),

            /// Community profile info
            BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
              builder: (context, state) {
                return state.estate.mayBeWhen(
                  elseMaybe: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loaded: () => SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: context.onPrimary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircularImage(path: state.community.avatar),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(state.community.name,
                                      style: TextStyles.headline20(context)),
                                  if (state.community.createdAt.isNotNullEmpty)
                                    Text(state.community?.createdAt ?? "N/A",
                                        style: TextStyles.bodyText14(context)),
                                ],
                              )
                            ],
                          ),
                          if (state.community.description.isNotNullEmpty) ...[
                            const SizedBox(height: 10),
                            Text(state.community?.description,
                                style: TextStyles.bodyText15(context)),
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            /// Community Posts list
            BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
              builder: (context, state) {
                return state.estate.mayBeWhen(
                  elseMaybe: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loaded: () => !state.posts.notNullAndEmpty
                      ? const SliverToBoxAdapter(child: SizedBox(height: 10))
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            state.posts
                                .map((post) => Post(
                                      post: post,
                                      onPostAction: (action, model) {
                                        final state = context
                                            .read<CommunityProfileCubit>();
                                        action.when(
                                          upVote: () {
                                            state.handleVote(model,
                                                isUpVote: true);
                                          },
                                          downVote: () {
                                            state.handleVote(model,
                                                isUpVote: false);
                                          },
                                          like: () {},
                                          modify: () {
                                            state.updatePost(model);
                                          },
                                          favourite: () {},
                                          share: () {},
                                          report: () {},
                                          edit: () {},
                                          delete: () {},
                                        );
                                      },
                                      myUser: getIt<Session>().user,
                                    ))
                                .toList(),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
