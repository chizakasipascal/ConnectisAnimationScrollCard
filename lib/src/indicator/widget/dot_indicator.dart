import 'dart:math';
import 'package:connectisanimationscrollcard/src/indicator/widget/props.dart';
import 'package:connectisanimationscrollcard/src/services/screen_ratio.dart';
import 'package:flutter/material.dart';

class DotIndicator extends AnimatedWidget {
  late Color? selectedColor;
  late Color? unselectedColor;
  late Animatable<Color>? background;
  late Props props;
  late double? wf = ScreenRatio.widthRatio!;

  DotIndicator({Key? key, required this.props})
      : super(key: key, listenable: props.controller) {
    selectedColor = props.selectedColor ?? Colors.white;
    unselectedColor = props.unSelectedColor ?? Colors.transparent;
    background = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: unselectedColor,
          end: selectedColor,
        ) as Animatable<Color>,
      ),
    ]);
  }

  transformValue(index) {
    double? value;
    if (props.controller.hasClients) {
      value = max(
        0.0,
        1.0 -
            ((props.controller.page ?? props.controller.initialPage) - index)
                .abs(),
      );
    }
    return value ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ...List.generate(
              props.totalPage!,
              (int index) => Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: (((props.width! * wf!) / (props.totalPage!))
                          .clamp(1.0, 8.0)),
                      width: (((props.width! * wf!) / (props.totalPage!))
                          .clamp(1.0, 8.0)),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: selectedColor!),
                          color: transformValue(index) > 0.1
                              ? background!.evaluate(
                                  AlwaysStoppedAnimation(
                                    transformValue(index),
                                  ),
                                )
                              : unselectedColor),
                    ),
                  )).toList()
        ],
      ),
    );
  }
}
