import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/home/feed/post_feed_cubit.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/post.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/whats_new_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class Feedpage extends StatelessWidget {
  const Feedpage({Key key}) : super(key: key);

  Widget _postList(BuildContext context, List<PostModel> list) {
    return SliverList(
      delegate: SliverChildListDelegate(
          list.map((post) => Post(post: post)).toList()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      alignment: Alignment.center,
      child: CustomScrollView(
        slivers: [
          _appbar(context),
          BlocBuilder<PostFeedCubit, PostFeedState>(
            builder: (BuildContext context, PostFeedState state) {
              return state.when(
                initial: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator())),
                response: (estate, message) {
                  return _postList(context, estate.list);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
