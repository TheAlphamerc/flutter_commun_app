import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/post/detail/post_detail_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';

class PostDetailPage extends StatelessWidget {
  final OnPostAction onPostAction;
  const PostDetailPage({Key key, this.onPostAction}) : super(key: key);

  static Route<T> getRoute<T>(String postId) {
    return MaterialPageRoute(builder: (_) {
      return BlocProvider(
        create: (context) => PostDetailCubit(getIt<PostRepo>(), postId: postId),
        child: const PostDetailPage(),
      );
    });
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
    state.map(response: (estate) {
      estate.estate.mayBeWhen(
        elseMaybe: () {},
        delete: () {},
      );
    });
  }

  Future<bool> onWillPop(BuildContext context) async {
    Navigator.pop(context, context.read<PostDetailCubit>().statePost);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          child: Column(
            children: [
              BlocConsumer<PostDetailCubit, PostDetailState>(
                listener: listener,
                builder: (context, state) {
                  return state.when(response: (estate, message, model) {
                    return estate.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      loaded: () => Post(
                        onPostAction: (PostAction action, PostModel model) =>
                            handlePostAction(context, action, model),
                        post: model,
                        myUser: context.watch<PostDetailCubit>().myUser,
                      ),
                      erorr: () => Column(
                        children: [Text(message)],
                      ),
                      delete: () => const SizedBox.shrink(),
                    );
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
