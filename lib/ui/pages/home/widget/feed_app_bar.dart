import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';

class FeedAppBar extends StatelessWidget with PreferredSizeWidget {
  const FeedAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.primaryColor,
      title: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Title(
              color: Colors.white,
              child: Text(
                context.locale.my_feed,
                style: TextStyles.headline30(context).onPrimary(context),
              ),
            ).pR(15),
            Text(
              context.locale.trending,
              style: TextStyles.headline20(context)
                  .onPrimary(context)
                  .withOpacity(.5),
            ).pB(2),
            const Spacer(),
          ],
        ),
      ),

      /// Logout button is added here for short time untill we didn't found a proper place for it
      actions: [
        Center(
          child: OutlinedButton(
            onPressed: () {
              context.read<AppCubit>().logout();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              context.locale.logout,
              style: TextStyles.headline14(context).onPrimary(context),
            ),
          ),
        ).pT(20)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
