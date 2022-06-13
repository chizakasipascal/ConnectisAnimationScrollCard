import 'package:flutter/material.dart';
import 'dart:math';

class RotatingCarouselState extends StatelessWidget {
  int? currentPage;
  bool? initial = true;
  final dynamic props;

  RotatingCarouselState(this.props, {Key? key}) : super(key: key) {
    currentPage = 0;
  }

  initiate(index) {
    double? value;
    if (index == currentPage && initial!) value = 0.0;
    initial = false;
    return value!;
  }

  @override
  Widget build(BuildContext context) {
    int count = props.children.length;

    Widget caroselBuilder = PageView.builder(
        scrollDirection: props.axis,
        controller: props.controller,
        itemCount: count,
        onPageChanged: (i) {
          props.updatePositionCallBack(i);
          if (props.onPageChange != null) {
            props.onPageChange(i);
          }
          currentPage = i;
        },
        itemBuilder: (context, index) => builder(index, props.controller));
    return Center(
        child: SizedBox(
      height: props.height,
      width: props.width,
      child: props.axis == Axis.horizontal
          ? caroselBuilder
          : Container(
              child: caroselBuilder,
            ),
    ));
  }

  builder(int index, controller1) {
    return AnimatedBuilder(
      animation: controller1,
      builder: (context, child) {
        double value = 1.0;
        value = initial!
            ? initiate(index) ??
                //  controller1.page - index
                0
            : controller1.page - index;
        value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
        return RotationTransition(
          turns: AlwaysStoppedAnimation((value * ((180 * 6))) / 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Opacity(
                opacity: pow(value, 4).toDouble(),
                child: Material(
                  borderRadius: BorderRadius.circular(
                      (5 - ((1.0 - value) * 25)).clamp(0.1, 5.0)),
                  elevation: (value > 0.9 ? 50.0 : 0.0),
                  child: SizedBox(
                    height: props.height * value,
                    width: props.width * value,
                    child: props.children[index],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
