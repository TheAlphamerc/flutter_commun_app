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

class Feedpage extends StatelessWidget {
  const Feedpage({Key key}) : super(key: key);

  Widget _postList(BuildContext context, List<PostModel> list) {
    return SliverList(
      delegate: SliverChildListDelegate(
        list
            .map(
              (post) => Post(
                post: post,
                onPostAction: (action, model) =>
                    onPostAction(context, action, model),
                myUser: getIt<Session>().user,
              ),
            )
            .toList(),
        addAutomaticKeepAlives: false,
      ),
    );
  }

  void onPostAction(BuildContext context, PostAction action, PostModel model) {
    action.when(elseMaybe: () {
      Utility.cprint("${action.toString()} is in development");
    }, delete: () async {
      await context.read<PostFeedCubit>().deletePost(model);
    }, upVote: () async {
      await context.read<PostFeedCubit>().handleVote(model, isUpVote: true);
    }, downVote: () async {
      await context.read<PostFeedCubit>().handleVote(model, isUpVote: false);
    }, modify: () {
      context.read<PostFeedCubit>().updatePost(model);
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
          Text("No post avalilable", style: TextStyles.headline16(context)),
          Text("Wanna see some posts ? Join Community",
              style: TextStyles.subtitle14(context)),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      alignment: Alignment.center,
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<PostFeedCubit>().getPosts();
        },
        child: CustomScrollView(
          slivers: [
            _appbar(context),
            BlocBuilder<PostFeedCubit, PostFeedState>(
              builder: (BuildContext context, PostFeedState state) {
                return state.when(
                  initial: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator())),
                  response: (estate, message) {
                    return estate.estate.mayBeWhen(
                      elseMaybe: () =>
                          const SliverToBoxAdapter(child: SizedBox()),
                      erorr: () => _noPosts(context),
                      loaded: () => _postList(context, estate.list),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
