import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/post/detail/post_detail_cubit.dart';
import 'package:flutter_commun_app/helper/file_utility.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/pages/post/widget/create_post_images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class CommentEntryField extends StatelessWidget {
  const CommentEntryField({Key? key}) : super(key: key);

  Widget _bottomEntryField(BuildContext context) {
    var state = context.watch<PostDetailCubit>();
    final col = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          state.files!.value.fold(() => const SizedBox(), (files) {
            if (!files.notNullAndEmpty) {
              return const SizedBox();
            }
            final postType =
                context.select((PostDetailCubit cubit) => cubit.postType);
            return postType.whenMaybe(() => const SizedBox(), image: () {
              return Container(
                width: context.width,
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecorations.decoration(context),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  children: files.map((file) {
                    return FittedBox(
                      child: SizedBox(
                          height: context.width * .42,
                          width: context.width * .42,
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: CreatePostImage(
                                image: file,
                                onImageRemove: (image) {
                                  context
                                      .read<PostDetailCubit>()
                                      .removeFiles(image);
                                }),
                          )),
                    );
                  }).toList(),
                ),
              );
            }, document: () {
              return Container(
                width: context.width,
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecorations.decoration(context),
                child: Column(
                    children: files.map((file) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.theme.dividerColor),
                    ),
                  ).pB(8);
                }).toList()),
              );
            });
          }),
          const Divider(thickness: 0, height: 1),
          Container(
            color: context.onPrimary,
            child: Row(
              children: [
                _camera(context).hP8,
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: KColors.light_gray,
                      // border: Border.all(
                      //   color: Theme.of(context).dividerColor,
                      // ),
                    ),
                    child: TextField(
                      controller: context.select(
                          (PostDetailCubit cubit) => cubit.commentController),
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        alignLabelWithHint: true,
                        hintText: context.locale.add_a_comment,
                        hintStyle: TextStyles.subtitle16(context),
                        border: InputBorder.none,
                      ),
                    )).extended,
                BlocBuilder<PostDetailCubit, PostDetailState>(
                  builder: (context, state) {
                    final bool isLoading =
                        state.estate == EPostDetailState.savingComment;
                    return FloatingActionButton(
                      onPressed: () async {
                        if (isLoading) {
                          return;
                        }
                        await context
                            .read<PostDetailCubit>()
                            .addComment(context);
                      },
                      mini: true,
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(context.onPrimary),
                              ),
                            )
                          : const Icon(Icons.keyboard_arrow_up_outlined),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Align(
      alignment: Alignment.bottomLeft,
      child: BlocBuilder<PostDetailCubit, PostDetailState>(
        builder: (context, state) {
          return state.map(
            response: (estate) {
              return state.estate.mayBeWhen(
                elseMaybe: () => col,
                loading: () => const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _camera(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.iconTheme.color!, width: 2.4),
      ),
      alignment: Alignment.center,
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.theme.iconTheme.color!, width: 2.4),
        ),
      ),
    ).ripple(() {
      FileUtility.chooseImageBottomSheet(context, (file) {
        file.fold(() => null, (a) {
          context.read<PostDetailCubit>().selectFile(a, AttachmentType.Image);
        });
      });
    }, radius: 8);
  }

  @override
  Widget build(BuildContext context) {
    return _bottomEntryField(context);
  }
}
