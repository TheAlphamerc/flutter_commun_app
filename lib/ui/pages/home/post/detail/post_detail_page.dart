import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/post/detail/post_detail_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/ui/pages/home/post/comment/comment.dart';
import 'package:flutter_commun_app/ui/pages/home/post/detail/widget/comment_entry_field.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class PostDetailPage extends StatelessWidget {
  final OnPostAction onPostAction;
  const PostDetailPage({Key? key, required this.onPostAction})
      : super(key: key);

  static Route<T> getRoute<T>(String postId,
      {required OnPostAction onPostAction}) {
    return MaterialPageRoute(builder: (_) {
      return BlocProvider(
        create: (context) => PostDetailCubit(getIt<PostRepo>(), postId: postId),
        child: PostDetailPage(onPostAction: onPostAction),
      );
    });
  }

  Widget _comments(BuildContext context, List<PostModel>? list) {
    return list.value.fold(
      () => const SliverToBoxAdapter(
        child: SizedBox(),
      ),
      (a) => SliverPadding(
        padding: const EdgeInsets.only(bottom: 70),
        sliver: SliverList(
            delegate: SliverChildListDelegate(list!
                .map((e) => Comment(
                      post: e,
                      type: PostType.reply,
                      myUser: context.watch<PostDetailCubit>().myUser,
                      margin: EdgeInsets.zero,
                    ))
                .toList())),
      ),
    );
  }

  Widget _post(BuildContext context, PostModel model) {
    return Post(
      type: PostType.detail,
      onPostAction: (PostAction action, PostModel model) =>
          handlePostAction(context, action, model),
      post: model,
      myUser: context.watch<PostDetailCubit>().myUser,
      margin: EdgeInsets.zero,
    );
  }

  Widget _loader(BuildContext context) {
    return Container(
        height: context.height - 100,
        alignment: Alignment.center,
        child: const CircularProgressIndicator());
  }

  void handlePostAction(
      BuildContext context, PostAction action, PostModel model) {
    action.when(
      elseMaybe: () {},
      delete: () {
        context.read<PostDetailCubit>().deletePost(model);
        Navigator.pop(context);
        // Navigator.pop(context, PostAction.delete);
      },
      upVote: () {
        context.read<PostDetailCubit>().handleVote(model, isUpVote: true);
      },
      downVote: () {
        context.read<PostDetailCubit>().handleVote(model, isUpVote: false);
      },
    );
  }

  void listener(BuildContext context, PostDetailState state) {
    state.estate.mayBeWhen(
      elseMaybe: () {},
      delete: () {},
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    Navigator.pop(context, context.read<PostDetailCubit>().state.post);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        body: SizedBox(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: context.onPrimary,
                    title: Text(context.locale.thread,
                        style: TextStyles.headline20(context)),
                    leading: IconButton(
                      icon: Icon(CupertinoIcons.chevron_back,
                          color: context.theme.iconTheme.color),
                      onPressed: () async {
                        await onWillPop(context);
                      },
                    ),
                    elevation: 1,
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(1),
                      child: Divider(height: 1),
                    ),
                    snap: true,
                    floating: true,
                  ),
                  SliverToBoxAdapter(
                    child: BlocConsumer<PostDetailCubit, PostDetailState>(
                      listener: listener,
                      buildWhen: (previous, current) {
                        if (current.estate == EPostDetailState.loading ||
                            current.estate == EPostDetailState.loaded) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        return state.estate.when(
                          loading: () => _loader(context),
                          loaded: () => _post(context, state.post!),
                          erorr: () => Column(children: [Text(state.message!)]),
                          delete: () => const SizedBox.shrink(),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: context.onPrimary,
                      child: Row(
                        children: [
                          Text(context.locale.comments,
                              style: TextStyles.headline20(context)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    context.primaryColor)),
                            child: Text(
                              context.locale.newest_first,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, size: 20)
                        ],
                      ).hP16,
                    ),
                  ),
                  BlocBuilder<PostDetailCubit, PostDetailState>(
                    buildWhen: (previous, current) {
                      if (current.estate == EPostDetailState.loading ||
                          current.estate == EPostDetailState.loaded) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      return state.estate.mayBeWhen(
                        elseMaybe: () => const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        ),
                        loaded: () => _comments(context, state.comments),
                      );
                    },
                  ),
                ],
              ),
              const CommentEntryField()
            ],
          ),
        ),
      ),
    );
  }
}
