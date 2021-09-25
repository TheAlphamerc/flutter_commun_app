import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/profile/community_profile_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';
import 'package:flutter_commun_app/ui/widget/image_viewer.dart';
import 'package:flutter_commun_app/ui/widget/kit/alert.dart';
import 'package:flutter_commun_app/ui/widget/lazy_load_scrollview.dart';

class CommunityProfilePage extends StatelessWidget {
  const CommunityProfilePage({Key? key}) : super(key: key);

  static Route<T> getRoute<T>(
      {CommunityModel? community, String? communityId}) {
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

  Widget _communityBanner(BuildContext context, CommunityModel community) {
    // return const SliverToBoxAdapter(
    //   child: Text("dsf sfskdf ksjfjfdkjfekrf"),
    // );
    return SliverAppBar(
      expandedHeight: context.height * .23,
      flexibleSpace: FlexibleSpaceBar(
        background: !community.banner.isNotNullEmpty
            ? Container(color: context.theme.cardColor)
            : CacheImage(path: community.banner!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _communityProfile(BuildContext context, CommunityModel community) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.onPrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircularImage(path: community.avatar),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(community.name!,
                        style: TextStyles.headline20(context)),
                    if (community.createdAt.isNotNullEmpty)
                      Text(community.createdAt ?? "N/A",
                          style: TextStyles.bodyText14(context)),
                  ],
                )
              ],
            ),
            if (community.description.isNotNullEmpty) ...[
              const SizedBox(height: 10),
              Text(community.description!,
                  style: TextStyles.bodyText15(context)),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: SizedBox(
        child: LazyLoadScrollView(
          onEndOfPage: () async {
            await context.read<CommunityProfileCubit>().getMorePosts();
          },
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox()),

              /// Community banner image
              BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
                builder: (context, state) {
                  return state.estate.mayBeWhen(
                    elseMaybe: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    loaded: () => _communityBanner(context, state.community!),
                    loadingMore: () =>
                        _communityBanner(context, state.community!),
                  );
                },
              ),

              /// Community profile info
              BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
                builder: (context, state) {
                  return state.estate.mayBeWhen(
                    elseMaybe: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    loaded: () => _communityProfile(context, state.community!),
                    loadingMore: () =>
                        _communityProfile(context, state.community!),
                  );
                },
              ),

              /// Community Posts list
              BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
                builder: (context, state) {
                  return state.estate.mayBeWhen(
                    elseMaybe: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    loaded: () => CommunityPostsList(posts: state.posts!),
                    loadingMore: () => CommunityPostsList(posts: state.posts!),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityPostsList extends StatelessWidget {
  const CommunityPostsList({Key? key, required this.posts}) : super(key: key);
  final List<PostModel> posts;

  void onPostAction(BuildContext context, PostAction action, PostModel model) {
    action.when(elseMaybe: () {
      Utility.cprint(
          "${action.toString()} ${context.locale.is_in_development}");
    }, delete: () async {
      Alert.confirmDialog(
        context,
        message: context.locale.confirm_delete_post,
        onConfirm: () async {
          await context.read<CommunityProfileCubit>().deletePost(model);
        },
      );
    }, upVote: () async {
      await context
          .read<CommunityProfileCubit>()
          .handleVote(model, isUpVote: true);
    }, downVote: () async {
      await context
          .read<CommunityProfileCubit>()
          .handleVote(model, isUpVote: false);
    }, modify: () {
      context.read<CommunityProfileCubit>().updatePost(model);
    }, report: () {
      context.read<CommunityProfileCubit>().reportPost(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    return posts.on(
      nul: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      empty: () => const SliverToBoxAdapter(
        child: Center(child: Text("No Post available")),
      ),
      value: () => SliverList(
        delegate: SliverChildListDelegate.fixed([
          ...posts
              .map((post) => SizedBox(
                    child: Post(
                      post: post,
                      onPostAction: (action, model) =>
                          onPostAction(context, action, model),
                      myUser: getIt<Session>().user!,
                    ),
                  ))
              .toList(),
          BlocBuilder<CommunityProfileCubit, CommunityProfileState>(
            builder: (context, state) {
              return state.estate.mayBeWhen(
                elseMaybe: () => const SizedBox(),
                loadingMore: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
          ),
        ]),
      ),
    );
  }
}
