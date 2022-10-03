import 'package:flutter/material.dart';
import 'package:connectisanimationscrollcard/src/indicator/widget/bar_indicator.dart';
import 'package:connectisanimationscrollcard/src/indicator/widget/bubble_indicator.dart';
import 'package:connectisanimationscrollcard/src/indicator/widget/dot_indicator.dart';
import 'package:connectisanimationscrollcard/src/indicator/widget/props.dart';
import 'package:connectisanimationscrollcard/src/services/type_declaration.dart';

class Indicator extends StatelessWidget {
  final int? currentPage;
  final dynamic? indicatorName;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final int? totalPage;
  final double? width;
  final PageController controller;

  const Indicator({
    this.currentPage,
    this.indicatorName,
    this.selectedColor,
    this.unSelectedColor,
    this.width,
    this.totalPage,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Props props = Props(
        currentPage: currentPage!,
        selectedColor: selectedColor!,
        totalPage: totalPage!,
        unSelectedColor: unSelectedColor!,
        width: width!,
        controller: controller);
    return getIndicator(indicatorName, props);
  }
}

Widget getIndicator(
  var indicatorName,
  Props props,
) {
  IndicatorTypes indicatorType = indicatorName.runtimeType == IndicatorTypes
      ? indicatorName
      : _getIndicatorType(indicatorName);

  Widget indicator;

  switch (indicatorType) {
    case IndicatorTypes.bar:
      {
        indicator = BarIndicator(
          props: props,
        );
      }
      break;
    case IndicatorTypes.bubble:
      {
        indicator = BubbleIndicator(
          props: props,
        );
      }
      break;
    case IndicatorTypes.dot:
      {
        indicator = DotIndicator(
          props: props,
        );
      }
      break;
    default:
      return const SizedBox();
  }
  return indicator;
}

IndicatorTypes? _getIndicatorType(String indicatorName) {
  switch (indicatorName) {
    case "bar":
      return IndicatorTypes.bar;

    case "bubble":
      return IndicatorTypes.bubble;

    case "dot":
      return IndicatorTypes.dot;
  }
  return null;
}
