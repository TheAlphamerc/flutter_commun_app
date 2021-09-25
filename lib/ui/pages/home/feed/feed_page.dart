import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/home/feed/post_feed_cubit.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/whats_new_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/kit/alert.dart';
import 'package:flutter_commun_app/ui/widget/lazy_load_scrollview.dart';

class Feedpage extends StatelessWidget {
  const Feedpage({Key? key}) : super(key: key);

  Widget _postList(BuildContext context, List<PostModel> list) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ...list
              .map(
                (post) => Post(
                  post: post,
                  onPostAction: (action, model) =>
                      onPostAction(context, action, model),
                  myUser: getIt<Session>().user!,
                  isFeedPost: true,
                ),
              )
              .toList(),
          BlocBuilder<PostFeedCubit, PostFeedState>(
            builder: (context, state) {
              return state.estate.mayBeWhen(
                elseMaybe: () => const SizedBox(),
                loadingMore: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
          ),
        ],
        addAutomaticKeepAlives: false,
      ),
    );
  }

  void onPostAction(BuildContext context, PostAction action, PostModel model) {
    action.when(elseMaybe: () {
      Utility.cprint(
          "${action.toString()} ${context.locale.is_in_development}");
    }, delete: () async {
      Alert.confirmDialog(
        context,
        message: context.locale.confirm_delete_post,
        onConfirm: () async {
          await context.read<PostFeedCubit>().deletePost(model);
        },
      );
    }, upVote: () async {
      await context.read<PostFeedCubit>().handleVote(model, isUpVote: true);
    }, downVote: () async {
      await context.read<PostFeedCubit>().handleVote(model, isUpVote: false);
    }, modify: () {
      context.read<PostFeedCubit>().updatePost(model);
    }, report: () {
      context.read<PostFeedCubit>().reportPost(model);
    });
  }

  Widget _appbar(BuildContext context) {
    return SliverPadding(
      sliver: SliverAppBar(
        floating: true,
        elevation: 0,
        pinned: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleSpacing: 0.0,
        title: SizedBox(width: context.width, child: const WhatsNewWidget()),
        leadingWidth: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 16),
    );
  }

  Widget _noPosts(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
      height: context.height * .7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.locale.no_post_available,
              style: TextStyles.headline16(context)),
          Text(context.locale.wanna_see_post,
              style: TextStyles.subtitle14(context)),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height,
        width: context.width,
        alignment: Alignment.center,
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<PostFeedCubit>().getPosts();
          },
          child: LazyLoadScrollView(
            onEndOfPage: () async {
              await context.read<PostFeedCubit>().getMorePosts();
            },
            child: CustomScrollView(
              slivers: [
                _appbar(context),
                BlocBuilder<PostFeedCubit, PostFeedState>(
                  builder: (BuildContext context, PostFeedState state) {
                    return state.estate.mayBeWhen(
                      elseMaybe: () => const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      loaded: () => _postList(context, state.list!),
                      erorr: () => _noPosts(context),
                      loadingMore: () => _postList(context, state.list!),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
