import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/bottom_menu/bottom_main_menu_cubit.dart';
import 'package:flutter_commun_app/cubit/community/feed/community_feed_cubit.dart';
import 'package:flutter_commun_app/cubit/home/feed/post_feed_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/ui/pages/community/community_feed.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/feed_page.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/bottom_navigation_menu.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/feed_app_bar.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostFeedCubit(getIt<PostRepo>())..getPosts(),
          ),
          BlocProvider(
            create: (context) => CommunityFeedCubit(getIt<CommunityFeedRepo>()),
          ),
          BlocProvider(create: (context) => BottomMainMenuCubit())
        ],
        child: const HomePage(),
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _body() {
    return SafeArea(
      child: SizedBox(
        child: BlocBuilder<BottomMainMenuCubit, BottomMainMenuState>(
          builder: (context, state) {
            return state.map(
              initial: (state) => _getPage(state.pageIndex),
              changeIndex: (state) => _getPage(state.pageIndex),
            );
          },
        ),
      ),
    );
  }

  Widget _appBar() {
    return BlocBuilder<BottomMainMenuCubit, BottomMainMenuState>(
      builder: (context, state) {
        return state.map(
          initial: (state) => _getAppBar(state.pageIndex),
          changeIndex: (state) => _getAppBar(state.pageIndex),
        );
      },
    );
  }

  Widget _getAppBar(int index) {
    switch (index) {
      case 0:
        return const FeedAppBar();
      case 1:
        return const PreferredSize(
            preferredSize: Size(0, 0),
            child: SizedBox(
              height: 30,
            ));
      // const CommunityFeedAppBar();
      default:
        return const FeedAppBar();
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Feedpage();
      case 1:
        return const CommunityFeed();
      default:
        return const Feedpage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), child: _appBar()),
      bottomNavigationBar: const BottomNavigationMenu(),
      body: _body(),
    );
  }
}
