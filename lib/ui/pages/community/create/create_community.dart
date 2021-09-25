import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/create/create_community_cubit.dart';
import 'package:flutter_commun_app/helper/file_utility.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/ui/pages/community/create/select_community_topic.dart';
import 'package:flutter_commun_app/ui/pages/community/create/widget/nav_slider_panel.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield2.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';

class CreateCommunityWidget extends StatelessWidget {
  final Function(CommunityModel model) onCommunityCreated;
  const CreateCommunityWidget({Key? key, required this.onCommunityCreated})
      : super(key: key);

  void nextPressed(BuildContext context) {
    final isValid =
        context.read<CreateCommunityCubit>().formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    Navigator.push(
      context,
      SelectCommunityTopicSheet.getRoute(context.read<CreateCommunityCubit>()),
    );
  }

  @override
  Widget build(BuildContext rootContext) {
    return Material(
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (BuildContext context) =>
                CreateCommunityCubit(getIt<CommunityFeedRepo>()),
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
                                  Text(context.locale.create_community,
                                      style: TextStyles.headline16(context)),
                                  const Spacer(),
                                  CircleAvatar(
                                    radius: 15,
                                    foregroundColor:
                                        context.theme.iconTheme.color,
                                    backgroundColor: context.onPrimary,
                                    child: const Icon(Icons.close),
                                  ).ripple(() {
                                    Navigator.pop(rootContext);
                                  })
                                ],
                              ).pB(40),
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  const _BannerImage().pB(40),
                                  const _UserAvatar(),
                                ],
                              ).pB(40),
                              KTextField2(
                                      type: FieldType.name,
                                      controller: context
                                          .watch<CreateCommunityCubit>()
                                          .name,
                                      label: context.locale.community_name)
                                  .pB(16),
                              KTextField2(
                                controller: context
                                    .watch<CreateCommunityCubit>()
                                    .description,
                                label: context.locale.description,
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
                                msg: context
                                    .locale.community_created_sucessfully);
                            onCommunityCreated(state.community!);

                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(rootContext);
                          }
                        },
                        child: NavSliderPanel(
                          hideBackButton: true,
                          currentPage: 0,
                          pageCount: 3,
                          onNextPressed: () => nextPressed(context),
                        ).pB(30),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key? key,
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
              Container(
                color: KColors.light_gray,
                child: CustomPaint(
                  painter:
                      CircleBorderPainter(color: context.onPrimary, stroke: 2),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset(Images.onBoardPicFour),
                  ),
                ),
              ).circular,
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

class _BannerImage extends StatelessWidget {
  const _BannerImage({
    Key? key,
  }) : super(key: key);

  void pickImage(BuildContext context) {
    FileUtility.chooseImageBottomSheet(context, (file) {
      context.read<CreateCommunityCubit>().updateImage(
            file: file,
            isBanner: true,
          );
    });
  }

  Widget _cameraIcon(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: CircleAvatar(
        backgroundColor: context.disabledColor.withOpacity(.4),
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
    return context.select((CreateCommunityCubit cubit) => cubit.banner).fold(
          () => Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                      width: context.width,
                      height: context.height * .2,
                      color: context.primaryColor)
                  .cornerRadius(10),
              _cameraIcon(context).p(12),
            ],
          ).ripple(() {
            pickImage(context);
          }, borderRadius: BorderRadius.circular(100)),
          (image) => SizedBox(
            width: context.width,
            height: context.height * .2,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecorations.decoration(context).copyWith(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _cameraIcon(context).p(12),
              ],
            ),
          ),
        );
  }
}
