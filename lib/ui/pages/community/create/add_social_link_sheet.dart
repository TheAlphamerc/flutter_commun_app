import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/create/create_community_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/route/fade_route.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/ui/pages/community/create/widget/nav_slider_panel.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield2.dart';
import 'package:flutter_commun_app/ui/widget/kit/custom_bottom_sheet.dart';

class AddSocialLinkSheet extends StatelessWidget {
  final Function(CommunityModel model)? onCommunityCreated;
  final CreateCommunityCubit cubit;
  const AddSocialLinkSheet(
      {Key? key, this.onCommunityCreated, required this.cubit})
      : super(key: key);
  static Route<T> getRoute<T>(CreateCommunityCubit cubit) {
    return FadeRoute(
      builder: (BuildContext context) => BlocProvider.value(
        value: cubit,
        child: AddSocialLinkSheet(cubit: cubit),
      ),
    );
  }

  Widget _topicField(BuildContext context, CommunityLinks links) {
    final index = context
        .watch<CreateCommunityCubit>()
        .socialLinksControllers
        .indexOf(links);
    return Container(
      color: context.onPrimary,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Image.asset(Images.getSocialCircleImage(links.type), height: 30)
                    .pR(10),
                Text(links.type.encode()!,
                        style: TextStyles.headline16(context))
                    .extended,
                // if (index != 0)
                CircleAvatar(
                  radius: 15,
                  foregroundColor: context.theme.iconTheme.color,
                  backgroundColor: context.theme.backgroundColor,
                  child: const Icon(Icons.close),
                ).ripple(() {
                  context.read<CreateCommunityCubit>().removeLink(index);
                }, radius: 15).p(4)
              ],
            ),
          ),
          KTextField2(
            type: FieldType.url,
            controller: links.controller,
            label: context.locale.weblink,
            containerDecoration: BoxDecoration(
              color: context.onPrimary,
              border: Border(
                  top: BorderSide(
                color: context.theme.dividerColor,
                width: .5,
              )),
            ),
          )
        ],
      ),
    ).cornerRadius(8).pB(15);
  }

  double bottomPadding(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (bottomInset > 0) {
      return bottomInset;
    } else {
      return 150;
    }
  }

  void nextPressed(BuildContext context) {
    final isValid = context
        .read<CreateCommunityCubit>()
        .linksFormKey
        .currentState!
        .validate();
    if (!isValid) {
      /// Returns if any of the provided social is invlid
      return;
    }
    context.read<CreateCommunityCubit>().createCommunity(context);
    // showCupertinoModalBottomSheet(
    //             context: context,
    //             expand: false,
    //             builder: (_) => CreateCommunityWidget(
    //                 onCommunityCreated: onCommunityCreated));
  }

  void addLinkSheet(BuildContext context) {
    sheet.displayBottomSheet(
      context,
      headerChild:
          Text(context.locale.add_link, style: TextStyles.headline16(context)),
      sheetButton: [
        PrimarySheetButton(
          title: "Instagram",
          onPressed: () {
            addLink(context, ESocialLinkType.instagram);
          },
          prefixChild:
              Image.asset(Images.circleInstagramIcon, height: 30).pR(8),
        ),
        PrimarySheetButton(
          title: "Facebook",
          onPressed: () {
            addLink(context, ESocialLinkType.facebook);
          },
          prefixChild: Image.asset(Images.circleFacebookIcon, height: 30).pR(8),
        ),
        PrimarySheetButton(
          title: "Twitter",
          onPressed: () {
            addLink(context, ESocialLinkType.twitter);
          },
          prefixChild: Image.asset(Images.circleTwitterIcon, height: 30).pR(8),
        ),
        PrimarySheetButton(
          title: "Linkedin",
          onPressed: () {
            addLink(context, ESocialLinkType.linkedin);
          },
          prefixChild: Image.asset(Images.circleLinkedinIcon, height: 30).pR(8),
        ),
        PrimarySheetButton(
          title: "Youtube",
          onPressed: () {
            addLink(context, ESocialLinkType.youtube);
          },
          prefixChild: Image.asset(Images.circleYoutubeIcon, height: 30).pR(8),
        ),
      ],
    );
  }

  void addLink(BuildContext context, ESocialLinkType type) {
    context.read<CreateCommunityCubit>().addLinkTopic(type);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        color: KColors.light_gray,
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Form(
              key: context.watch<CreateCommunityCubit>().linksFormKey,
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(context.locale.add_social_links,
                              style: TextStyles.headline16(context)),
                          const Spacer(),
                        ],
                      ).pB(40),
                      Image.asset(Images.onBoardPicTwo, height: 100).pV(20),
                      Text(context.locale.social_link_description_in_community,
                              style: TextStyles.bodyText15(context),
                              textAlign: TextAlign.center)
                          .pV(20),
                      ...[
                        for (var object in context
                            .watch<CreateCommunityCubit>()
                            .socialLinksControllers)
                          _topicField(context, object)
                      ],
                      Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        color: context.onPrimary,
                        child: Text(
                          "+ ${context.locale.add_new_link}",
                          style:
                              TextStyles.headline16(context).primary(context),
                        ),
                      ).cornerRadius(8).ripple(() {
                        FocusManager.instance.primaryFocus!.unfocus();

                        addLinkSheet(context);
                      }, radius: 8),
                    ],
                  ),
                ).pB(bottomPadding(context)),
              ),
            ),
            Container(
                    color: KColors.light_gray,
                    child: NavSliderPanel(
                            currentPage: 2,
                            pageCount: 3,
                            onNextPressed: () => nextPressed(context),
                            nextButtonText: context.locale.create)
                        .pB(30))
                .alignBottomCenter,
          ],
        ),
      ),
    );
  }
}
