import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/pages/community/create/widget/next_buton.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class NavSliderPanel extends StatelessWidget {
  final Function() onNextPressed;
  final bool hideBackButton;
  final int pageCount;
  final int currentPage;
  final String? nextButtonText;
  const NavSliderPanel(
      {Key? key,
      required this.onNextPressed,
      this.hideBackButton = false,
      required this.currentPage,
      required this.pageCount,
      this.nextButtonText = "Next"})
      : super(key: key);
  Widget _button(BuildContext context,
      {required String title,
      required VoidCallback onPressed,
      bool isPrimary = true}) {
    return SecondaryButton(
      title: title,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      onPressed: () => onPressed(),
      textColor: isPrimary ? context.onPrimary : context.primaryColor,
      backgroundColor: isPrimary
          ? context.primaryColor
          : context.primaryColor.withOpacity(.1),
      borderSide: null,
    );
  }

  Widget _indicator(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Iterable<Widget>.generate(
            pageCount, (index) => _dot(context, index)).toList(),
      ),
    );
  }

  Widget _dot(BuildContext context, int index) {
    final bool isSelected = currentPage == index;
    return Container(
      height: 9,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isSelected ? 30 : 8,
      decoration: BoxDecoration(
        color: isSelected
            ? context.primaryColor
            : context.primaryColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: const ValueKey("NavSlidePanelKey"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Visibility(
              visible: !hideBackButton,
              replacement: const SizedBox(width: 50),
              child: _button(context,
                  title: context.locale.back, isPrimary: false, onPressed: () {
                Navigator.pop(context);
              }),
            ),
            _indicator(context).extended,
            // const Spacer(),
            _button(context,
                title: nextButtonText ?? context.locale.next,
                onPressed: onNextPressed),
          ],
        ),
      ),
    );
  }
}
