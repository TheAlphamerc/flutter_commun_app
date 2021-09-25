import 'package:flutter/material.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/ui/pages/community/create/create_community.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommunityFeedAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(CommunityModel model) onCommunityCreated;
  const CommunityFeedAppBar({Key? key, required this.onCommunityCreated})
      : super(key: key);

  void createCommunity(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        builder: (_) =>
            CreateCommunityWidget(onCommunityCreated: onCommunityCreated));
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
                  hintText: context.locale.search,
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
          tooltip: context.locale.create_community,
          child: const Icon(Icons.add),
        ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
