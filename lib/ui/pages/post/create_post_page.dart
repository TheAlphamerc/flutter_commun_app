import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/feed/community_feed_cubit.dart';
import 'package:flutter_commun_app/cubit/post/create/create_post_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/ui/pages/community/widget/community_tile.dart';
import 'package:flutter_commun_app/ui/pages/post/create_post_bottom_menu.dart';
import 'package:flutter_commun_app/ui/pages/post/widget/create_post_images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);
  static Route<T> getRoute<T>(CommunityModel community) {
    return MaterialPageRoute(builder: (_) {
      return BlocProvider(
        create: (context) => CreatePostCubit(
          postRepo: getIt<PostRepo>(),
          community: community,
        ),
        child: const CreatePostPage(),
      );
    });
  }

  static Route<T> getRoute2<T>(CommunityFeedCubit cubit) {
    return MaterialPageRoute(builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: BlocProvider(
          create: (context) => CreatePostCubit(postRepo: getIt<PostRepo>()),
          child: const CreatePostPage(),
        ),
      );
    });
  }

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late FocusNode node;

  @override
  void initState() {
    super.initState();
    node = FocusNode();
  }

  Widget _userAvatar(BuildContext context) {
    final community = context.watch<CreatePostCubit>().state.community;
    if (community != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (community.avatar != null &&
                  !community.avatar!.contains("object-not-found"))
                CircleAvatar(
                  radius: 20,
                  key: const ValueKey("user-profile"),
                  backgroundColor: KColors.light_gray,
                  backgroundImage: NetworkImage(community.avatar!),
                )
              else
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Images.onBoardPicFour),
                ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.locale.you_will_post_in,
                      style: TextStyles.subtitle14(context)
                          .copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 0),
                  Text(community.name!, style: TextStyles.headline16(context)),
                ],
              ),
              const Spacer(),
              const CircleAvatar(
                backgroundColor: KColors.light_gray,
                radius: 12,
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 25,
                  color: KColors.light_gray_2,
                ),
              ).p(8).ripple(
                  () =>
                      chooseCommunity(context, context.read<CreatePostCubit>()),
                  radius: 20),
            ],
          ),
        ),
      );
    }
    final user = getIt<Session>().user;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (user != null &&
                user.photoURL != null &&
                !user.photoURL!.contains("object-not-found"))
              CircleAvatar(
                radius: 20,
                key: const ValueKey("user-profile"),
                backgroundColor: KColors.light_gray,
                backgroundImage: NetworkImage(user.photoURL!),
              )
            else
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(Images.onBoardPicFour),
              ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.locale.you_will_post_in,
                    style: TextStyles.subtitle14(context)
                        .copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                const SizedBox(height: 0),
                Text(context.locale.timeline,
                    style: TextStyles.headline16(context)),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundColor: KColors.light_gray,
              radius: 12,
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 25,
                color: KColors.light_gray_2,
              ),
            ).p(8).ripple(
                () => chooseCommunity(context, context.read<CreatePostCubit>()),
                radius: 20),
          ],
        ),
      ),
    );
  }

  Widget _editor(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: context.watch<CreatePostCubit>().description,
          focusNode: node,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: false,
          enableSuggestions: false,
          maxLines: null,
          onEditingComplete: () {},
          onFieldSubmitted: (val) {},
          onSaved: (d) {},
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: context.locale.enter_text,
            hintStyle: TextStyles.subtitle16(context).normal,
          ),
        ),
      ),
    );
  }

  Widget _images(BuildContext context) {
    return context.watch<CreatePostCubit>().files.value.fold(
          () => SliverToBoxAdapter(
            child: Container(),
          ),
          (files) => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: files.length > 1 ? 2 : 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: files.map((file) {
                return CreatePostImage(
                  image: file,
                  onImageRemove: (image) =>
                      context.read<CreatePostCubit>().removeFile(image),
                );
              }).toList(),
            ),
          ),
        );
  }

  Widget _bottomSpace() {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
      ),
    );
  }

  void onImageSelected(File file) {
    context.read<CreatePostCubit>().addFiles([file]);
  }

  Future onPostSubmit() async {
    final selectedCommunity = context.read<CreatePostCubit>().state.community;

    if (selectedCommunity == null) {
      Utility.displaySnackbar(context,
          msg: "Choose a community before creating first");
      return;
    }
    await context.read<CreatePostCubit>().createPost(context);
  }

  void chooseCommunity(BuildContext context, CreatePostCubit postCubit) {
    /// TODO: Fetch community list from server if not available in postcubit
    showMaterialModalBottomSheet(
      context: context,
      builder: (_) => Builder(
        builder: (_) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: context.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Text(context.locale.communities,
                            style: TextStyles.headline16(context)),
                        const Spacer(),
                        CircleAvatar(
                          radius: 15,
                          foregroundColor: context.theme.iconTheme.color,
                          backgroundColor: context.onPrimary,
                          child: const Icon(Icons.close),
                        ).ripple(() {
                          Navigator.pop(context);
                        })
                      ],
                    ),

                    // const KTextField(
                    //   type: FieldType.optional,
                    //   hintText: "Search",
                    // ),
                  ],
                ),
              ),
              context.read<CommunityFeedCubit>().myCommunity.value.fold(
                    () => const SizedBox(),
                    (list) => Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CommunityTile(
                            model: list[index],
                            onTilePressed: () {
                              postCubit.setCommunity(list[index]);
                              Navigator.pop(context);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1);
                        },
                        itemCount: list.length,
                      ).cornerRadius(8),
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }

  void stateListener(BuildContext context, CreatePostState state) {
    state.when(
      response: (estate, messgae, community) {
        switch (estate) {
          case ECreatePostState.saved:
            Navigator.pop(context);
            break;

          case ECreatePostState.eror:
            Utility.displaySnackbar(context, msg: messgae!);
            break;

          default:
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: stateListener,
      builder: (BuildContext context, CreatePostState state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.cancel,
                color: KColors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(context.locale.create_post,
                style: TextStyles.headline16(context)),
            centerTitle: true,
            elevation: 0,
          ),
          bottomSheet: CreatePostBottomMenu(
            node: node,
            onSubmit: onPostSubmit,
            onImageSelected: onImageSelected,
            isLoading:
                state.map(response: (s) => s.estate == ECreatePostState.saving),
          ),
          body: SizedBox(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _userAvatar(context),
                _editor(context),
                _images(context),
                _bottomSpace()
              ],
            ),
          ),
        );
      },
    );
  }
}
