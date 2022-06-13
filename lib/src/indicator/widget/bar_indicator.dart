import 'package:connectisanimationscrollcard/src/indicator/widget/props.dart';
import 'package:flutter/material.dart';

class BarIndicator extends AnimatedWidget {
  final Props props;
  BarIndicator({required this.props}) : super(listenable: props.controller);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        height: 4.0,
        width: ((props.width)! * .80),
        color: props.unSelectedColor ?? const Color(0xff4C5158),
        padding: EdgeInsets.only(
          left: (((props.width! * 0.8) / props.totalPage!) *
              (props.controller.page ?? props.controller.initialPage)),
        ),
        child: Container(
          width: (props.width! * 0.8) / props.totalPage!,
          color: props.selectedColor ?? Colors.black,
        ));
  }
}
