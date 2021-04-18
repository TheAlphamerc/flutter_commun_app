import 'dart:math';

import 'package:flutter/material.dart';

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 6.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 1.5;

  // The distance between the center of each dot
  static const double _kDotSpacing = 8.0;

  Widget _buildDot(BuildContext context, int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.5 + (_kMaxZoom - 1.0) * selectedness;
    double width = 35.0;

    return new AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: _kDotSize * zoom + (width * selectedness),
      height: _kDotSize * zoom,
      margin: EdgeInsets.symmetric(horizontal: _kDotSpacing),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).disabledColor),
      child: new Center(
        child: new Material(
          color: color.withAlpha(10 + (255 - selectedness * 15).toInt()),
          type: MaterialType.card,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: new Container(
            width: _kDotSize * zoom + (width * selectedness),
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(
          itemCount, (index) => _buildDot(context, index)),
    );
  }
}
