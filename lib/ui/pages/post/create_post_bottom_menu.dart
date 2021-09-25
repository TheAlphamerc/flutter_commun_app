import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/file_utility.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class CreatePostBottomMenu extends StatelessWidget {
  const CreatePostBottomMenu(
      {Key? key,
      required this.node,
      required this.onSubmit,
      required this.onImageSelected,
      this.isLoading = false})
      : super(key: key);
  final FocusNode node;
  final VoidCallback onSubmit;
  final bool isLoading;
  final Function(File) onImageSelected;

  Widget _wrap(Widget child, {required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: KColors.light_gray),
      child: child,
    ).ripple(onPressed.call, radius: 20);
  }

  Widget _loader(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(context.onPrimary),
        strokeWidth: 2,
      ),
    );
  }

  void _handleKeyBoardFocus() {
    if (isLoading) {
      return;
    }
    if (node.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    } else {
      FocusManager.instance.primaryFocus!.requestFocus(node);
    }
  }

  void _handleImagePick(BuildContext context) {
    FileUtility.chooseImageBottomSheet(
      context,
      (file) => file.fold(
        () => null,
        (image) => onImageSelected(image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            children: [
              _wrap(
                const Icon(
                  Icons.keyboard,
                  size: 20,
                ),
                onPressed: _handleKeyBoardFocus,
              ).pR(10),
              _wrap(
                const Icon(
                  Icons.image,
                  size: 20,
                ),
                onPressed: () => _handleImagePick(context),
              ).pR(10),
              _wrap(
                  Row(
                    children: [
                      const Icon(MdiIcons.fileDocument, size: 18).pR(6),
                      Text(
                        context.locale.article,
                        style: TextStyles.subtitle14(context),
                      ),
                    ],
                  ),
                  onPressed: () {}),
              const Spacer(),
              SizedBox(
                height: 35,
                width: 60,
                child: FloatingActionButton.extended(
                  onPressed: onSubmit,
                  label: isLoading
                      ? _loader(context)
                      : Text(
                          context.locale.post,
                          style:
                              TextStyles.headline16(context).onPrimary(context),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
