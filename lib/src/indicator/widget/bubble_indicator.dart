import 'package:connectisanimationscrollcard/src/indicator/widget/props.dart';
import 'package:connectisanimationscrollcard/src/services/screen_ratio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BubbleIndicator extends AnimatedWidget {
  final Props props;
  BubbleIndicator({
    required this.props,
  }) : super(listenable: props.controller);
  transformValue(index) {
    if (props.controller.hasClients) {
      return props.controller.hasClients
          ? 1.0 +
              (Curves.easeOut.transform(
                max(
                  0.0,
                  1.0 -
                      ((props.controller.page ?? props.controller.initialPage) -
                              index)
                          .abs(),
                ),
              ))
          : 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double wf = ScreenRatio.widthRatio!;
    return Container(
      alignment: Alignment.topLeft,
      height: 40.0,
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ...List.generate(props.totalPage!, (int index) {
                return Center(
                  child: SizedBox(
                    width: ((props.width! * wf) / props.totalPage!)
                        .clamp(2.0, 40.0),
                    child: Center(
                      child: Container(
                        height: (((props.width! * wf) / (props.totalPage! * 2))
                                .clamp(1.0, 8.0)) *
                            transformValue(index),
                        width: (((props.width! * wf) / (props.totalPage! * 2))
                                .clamp(1.0, 8.0)) *
                            transformValue(index),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: props.selectedColor ?? Colors.white),
                      ),
                    ),
                  ),
                );
              })
            ]),
      ),
    );
  }
}
