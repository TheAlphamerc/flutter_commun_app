import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/create/create_community_cubit.dart';
import 'package:flutter_commun_app/helper/file_utility.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield2.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommunityFeedAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(CommunityModel model) onCommunityCreated;
  const CommunityFeedAppBar({Key key, this.onCommunityCreated})
      : super(key: key);

  void createCommunity(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      builder: (_) => BlocProvider(
          create: (context) => CreateCommunityCubit(getIt<CommunityFeedRepo>()),
          child: Builder(
            builder: (context) => Container(
              alignment: Alignment.bottomCenter,
              child: Material(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Form(
                      key: context.watch<CreateCommunityCubit>().formKey,
                      child: Container(
                        color: KColors.light_gray,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Create Community",
                                        style: TextStyles.headline16(context))
                                    .pB(40),
                                const Spacer(),
                                CircleAvatar(
                                  radius: 15,
                                  foregroundColor:
                                      context.theme.iconTheme.color,
                                  backgroundColor: context.onPrimary,
                                  child: const Icon(Icons.close),
                                ).ripple(() {
                                  Navigator.pop(context);
                                })
                              ],
                            ),
                            const _UserAvatar().pB(50),
                            KTextField2(
                              type: FieldType.name,
                              controller:
                                  context.watch<CreateCommunityCubit>().name,
                              label: "Community Name",
                            ).pB(16),
                            KTextField2(
                              controller: context
                                  .watch<CreateCommunityCubit>()
                                  .description,
                              label: "Description",
                              type: FieldType.optional,
                              maxLines: 4,
                            ).pB(40),
                          ],
                        ),
                      ),
                    ),
                    BlocListener<CreateCommunityCubit, CreateCommunityState>(
                      listener: (context, state) {
                        if (state.estate == ECreateCommunityState.saved) {
                          Utility.displaySnackbar(context,
                              msg: "Community Created successfully");
                          onCommunityCreated(state.community);

                          Navigator.pop(context);
                        }
                      },
                      child: _createCommunityButton(context,
                              title: "Create Community",
                              padding: const EdgeInsets.symmetric(vertical: 15))
                          .pB(30),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _createCommunityButton(BuildContext context,
      {String title,
      Color backgroundColor,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 20)}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          context.read<CreateCommunityCubit>().createCommunity(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.primaryColor),
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
            side: MaterialStateProperty.all(const BorderSide(width: .3))),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: context.onPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.onPrimary,
      title: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: KColors.light_gray,
                // border: Border.all(
                //   color: Theme.of(context).dividerColor,
                // ),
              ),
              child: TextField(
                // controller: context.select(
                //     (PostDetailCubit cubit) => cubit.commentController),
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10) +
                      const EdgeInsets.only(bottom: 10),
                  alignLabelWithHint: true,
                  hintText: 'Search',
                  hintStyle: TextStyles.subtitle16(context),
                  border: InputBorder.none,
                ),
              ),
            ).extended,
          ],
        ),
      ),

      /// Logout button is added here for short time untill we didn't found a proper place for it
      actions: [
        Center(
            child: FloatingActionButton(
          onPressed: () async {
            createCommunity(context);
          },
          mini: true,
          elevation: 0,
          heroTag: "Create_Community",
          tooltip: "Create Community",
          child: const Icon(Icons.add),
        ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key key,
  }) : super(key: key);

  void pickImage(BuildContext context) {
    FileUtility.chooseImageBottomSheet(context, (file) {
      context.read<CreateCommunityCubit>().updateImage(file: file);
    });
  }

  Widget _cameraIcon(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: CircleAvatar(
        backgroundColor: context.primaryColor,
        child: Icon(
          Icons.camera_alt,
          color: context.onPrimary,
        ),
      ).ripple(() {
        pickImage(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.select((CreateCommunityCubit cubit) => cubit.image).fold(
          () => Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomPaint(
                painter: CircleBorderPainter(color: context.disabledColor),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(Images.onBoardPicFour),
                ),
              ),
              _cameraIcon(context),
            ],
          ).ripple(() {
            pickImage(context);
          }, borderRadius: BorderRadius.circular(100)),
          (image) => SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecorations.decoration(context).copyWith(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      const BoxShadow(
                          color: Color(0xffaaaaaa),
                          offset: Offset(3, 3),
                          blurRadius: 10)
                    ],
                  ),
                ),
                _cameraIcon(context),
              ],
            ),
          ),
        );
  }
}
