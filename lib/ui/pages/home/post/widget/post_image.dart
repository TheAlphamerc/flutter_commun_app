import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/image_viewer.dart';

class PostImages extends StatelessWidget {
  final List<String>? list;
  const PostImages({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!list.notNullAndEmpty) return const SizedBox.shrink();
    final bool isPlusOne = list!.length > 4;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          width: width,
          child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children:
                  Iterable.generate(isPlusOne ? 4 : list!.length, (index) {
                final path = list![index];
                if (path.contains("not-found")) {
                  return const SizedBox.shrink();
                }
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: list!.length >= 2 ? (width - 32) * .5 : width - 16,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: CacheImage(
                              path: path,
                              fit: BoxFit.cover,
                              onPressed: () {},
                            ),
                          ),
                          if (isPlusOne && index == 3)
                            Container(
                                color:
                                    context.theme.dividerColor.withOpacity(.5),
                                alignment: Alignment.center,
                                child: Text("+${list!.length - 4}",
                                    style: TextStyles.headline18(context)
                                        .onPrimary(context)))
                        ],
                      ),
                    ),
                  ),
                ).p(4);
              }).toList()),
        );
      },
    );
  }
}
