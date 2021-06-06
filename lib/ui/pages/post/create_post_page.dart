import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/post/create_post_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/ui/pages/post/create_post_bottom_menu.dart';
import 'package:flutter_commun_app/ui/pages/post/widget/create_post_images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key key}) : super(key: key);
  static Route<T> getRoute<T>() {
    return MaterialPageRoute(builder: (_) {
      return BlocProvider(
        create: (context) => CreatePostCubit(postRepo: getIt<PostRepo>()),
        child: const CreatePostPage(),
      );
    });
  }

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  FocusNode node;

  @override
  void initState() {
    super.initState();
    node = FocusNode();
  }

  Widget _userAvatar(BuildContext context) {
    final user = getIt<Session>().user;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (user != null &&
                user.photoURL != null &&
                !user.photoURL.contains("object-not-found"))
              CircleAvatar(
                radius: 20,
                key: const ValueKey("user-profile"),
                backgroundColor: KColors.light_gray,
                backgroundImage: NetworkImage(user.photoURL),
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
                Text("You will post in",
                    style: TextStyles.subtitle14(context)
                        .copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                const SizedBox(height: 0),
                Text("Timeline", style: TextStyles.headline16(context)),
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
            ).p(8).ripple(() {}, radius: 20),
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
            hintText: "Enter text",
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
    await context.read<CreatePostCubit>().createPost(context);
  }

  void stateListener(BuildContext context, CreatePostState state) {
    state.when(
      initial: () {},
      response: (estate, messgae) {
        switch (estate) {
          case ECreatePostState.saved:
            Navigator.pop(context);
            break;

          case ECreatePostState.eror:
            Utility.displaySnackbar(context, msg: messgae);
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
            title: Text("Create Post", style: TextStyles.headline16(context)),
            centerTitle: true,
            elevation: 0,
          ),
          bottomSheet: CreatePostBottomMenu(
            node: node,
            onSubmit: onPostSubmit,
            onImageSelected: onImageSelected,
            isLoading: state.map(
                initial: (s) => false,
                response: (s) => s.estate == ECreatePostState.saving),
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
