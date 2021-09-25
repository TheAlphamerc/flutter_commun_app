import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/community/create/create_community_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/route/fade_route.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/ui/pages/community/create/add_social_link_sheet.dart';
import 'package:flutter_commun_app/ui/pages/community/create/widget/nav_slider_panel.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield2.dart';

class SelectCommunityTopicSheet extends StatelessWidget {
  final CreateCommunityCubit cubit;
  const SelectCommunityTopicSheet({Key? key, required this.cubit})
      : super(key: key);
  static Route<T> getRoute<T>(CreateCommunityCubit cubit) {
    return FadeRoute(
      builder: (BuildContext context) =>
          SelectCommunityTopicSheet(cubit: cubit),
    );
  }

  Widget _topicField(BuildContext context, TextEditingController controller) {
    final index = context
        .watch<CreateCommunityCubit>()
        .topicControllers
        .indexOf(controller);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        KTextField2(
          type: FieldType.text,
          controller: controller,
          label: context.locale.topic_name,
        ),
        // if (index != 0)
        CircleAvatar(
          radius: 15,
          foregroundColor: context.theme.iconTheme.color,
          backgroundColor: context.theme.backgroundColor,
          child: const Icon(Icons.close),
        ).ripple(() {
          context.read<CreateCommunityCubit>().removeTopic(index);
        }).p(4)
      ],
    ).pB(16);
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
        .topicsFormKey
        .currentState!
        .validate();
    if (!isValid) {
      return;
    }
    Navigator.push(
      context,
      AddSocialLinkSheet.getRoute(context.read<CreateCommunityCubit>()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Builder(
        builder: (context) => Container(
          color: KColors.light_gray,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Form(
                key: context.watch<CreateCommunityCubit>().topicsFormKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(context.locale.select_community_topic,
                                style: TextStyles.headline16(context)),
                            const Spacer(),
                          ],
                        ).pB(40),
                        Image.asset(Images.onBoardPicTwo, height: 100).pV(20),
                        Text(context.locale.topic_description_in_community,
                                style: TextStyles.bodyText15(context),
                                textAlign: TextAlign.center)
                            .pV(20),
                        ...[
                          for (var controller in context
                              .watch<CreateCommunityCubit>()
                              .topicControllers)
                            _topicField(context, controller)
                        ],
                        Container(
                          width: context.width,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          color: context.onPrimary,
                          child: Text(
                            "+ ${context.locale.add_new_topic}",
                            style:
                                TextStyles.headline16(context).primary(context),
                          ),
                        ).cornerRadius(8).ripple(() {
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<CreateCommunityCubit>().addTopic();
                        }, radius: 8)
                      ],
                    ),
                  ).pB(bottomPadding(context)),
                ),
              ),
              Container(
                      color: KColors.light_gray,
                      child: NavSliderPanel(
                        currentPage: 1,
                        pageCount: 3,
                        onNextPressed: () => nextPressed(context),
                      ).pB(30))
                  .alignBottomCenter,
            ],
          ),
        ),
      ),
    );
  }
}
