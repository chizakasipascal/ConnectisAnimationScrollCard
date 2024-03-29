library carousel;

import 'package:connectisanimationscrollcard/src/carousel/simple_carousel.dart';
import 'package:connectisanimationscrollcard/src/carousel/slide_swipe.dart';
import 'package:connectisanimationscrollcard/src/indicator/index.dart';
import 'package:connectisanimationscrollcard/src/services/renderer.dart';
import 'package:connectisanimationscrollcard/src/services/screen_ratio.dart';
import 'package:connectisanimationscrollcard/src/services/type_declaration.dart';
import 'package:flutter/material.dart';

typedef OnCarouselTap = Function(int);

class ConnectisCarouselScrollCard extends StatefulWidget {
  final dynamic type;

  ///The scroll Axis of Carousel
  final Axis? axis;

  final int? initialPage;

  dynamic updatePositionCallBack;

  /// call back function triggers when gesture tap is registered
  final OnCarouselTap? onCarouselTap;

  /// This feild is required.
  ///
  /// Defines the height of the Carousel
  final double? height;

  /// Defines the width of the Carousel
  final double? width;

  final List<Widget> children;

  ///  callBack function on page Change
  final onPageChange;

  /// Defines the Color of the active Indicator
  final Color? activeIndicatorColor;

  ///defines type of indicator to carousel
  final dynamic indicatorType;

  final bool? showArrow;

  ///defines the arrow colour
  final Color? arrowColor;

  ///choice to show indicator
  final bool showIndicator;

  /// Defines the Color of the non-active Indicator
  final Color? unActiveIndicatorColor;

  /// Paint the background of indicator with the color provided
  ///
  /// The default background color is Color(0xff121212)
  final Color? indicatorBackgroundColor;

  /// Defines if the carousel should wrap once you reach the end or if your at the begining and go left if it should take you to the end
  ///
  /// The default behavior is to allow wrapping
  final bool allowWrap;

  /// Provide opacity to background of the indicator
  ///
  /// An opacity of 1.0 is fully opaque. An opacity of 0.0 is fully transparent
  /// (i.e., invisible).
  ///
  /// The default value of opacity is 0.5 nothing is initialised.
  ///

  final double? indicatorBackgroundOpacity;
  dynamic updateIndicator;
  PageController controller;
  int currentPage = 0;

  @override
  GlobalKey? key;

  ConnectisCarouselScrollCard(
      {this.key,
      this.height,
      this.width,
      required this.controller,
      @required this.type,
      this.axis,
      this.showArrow,
      this.arrowColor,
      this.onPageChange,
      this.showIndicator = true,
      this.indicatorType,
      this.indicatorBackgroundOpacity,
      this.unActiveIndicatorColor,
      this.indicatorBackgroundColor,
      this.activeIndicatorColor,
      this.allowWrap = true,
      this.initialPage,
      this.onCarouselTap,
      required this.children})
      : assert(initialPage! >= 0 && initialPage < children.length,
            "intialPage must be a int value between 0 and length of children"),
        super(key: key) {
    createState();
  }
  @override
  createState() {
    return _ConnectisCarouselScrollCardState();
  }
}

class _ConnectisCarouselScrollCardState
    extends State<ConnectisCarouselScrollCard> {
  int position = 0;
  double? animatedFactor;
  double? offset;
  final GlobalKey<RendererState> rendererKey1 = GlobalKey();
  final GlobalKey<RendererState> rendererKey2 = GlobalKey();
  @override
  void initState() {
    widget.updatePositionCallBack = updatePosition;
    widget.controller = PageController();
    debugPrint('init page controller');
    super.initState();
  }

  @override
  dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  updatePosition(int index) {
    if (widget.controller.page!.round() == widget.children.length - 1) {
      rendererKey2.currentState!.updateRenderer(false);
    }
    if (widget.controller.page!.round() == widget.children.length - 2) {
      rendererKey2.currentState!.updateRenderer(false);
    }
    if (widget.controller.page!.round() == 1) {
      rendererKey1.currentState!.updateRenderer(false);
    }
    if (widget.controller.page!.round() == 0) {
      rendererKey1.currentState!.updateRenderer(false);
    }
  }

  scrollPosition(dynamic updateRender, {String? function}) {
    updateRender(false);

    if ((widget.controller.page!.round() == 0 && function == "back") ||
        widget.controller.page == widget.children.length - 1 &&
            function != "back") {
      if (widget.allowWrap) {
        widget.controller.jumpToPage(
            widget.controller.page!.round() == 0 && function == "back"
                ? widget.children.length - 1
                : 0);
      }
    } else {
      widget.controller.animateToPage(
          (function == "back"
              ? (widget.controller.page!.round() - 1)
              : (widget.controller.page!.round() + 1)),
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    offset = (widget.type.toString().toLowerCase() == "slideswiper" ||
            widget.type == Types.slideSwiper)
        ? 0.8
        : 1.0;
    Size size = MediaQuery.of(context).size;
    ScreenRatio.setScreenRatio(size: size);
    animatedFactor =
        widget.axis == Axis.horizontal ? widget.width : widget.height;
    widget.controller = PageController(
      initialPage: widget.initialPage ?? 0,
      keepPage: true,
      viewportFraction: offset!,
    );
    dynamic carousel = _getCarousel(widget);
    return Container(
        child: Stack(
      children: <Widget>[
        Center(
            child: GestureDetector(
          child: carousel,
          onTap: () {
            widget.onCarouselTap!(widget.controller.page!.round());
          },
        )),
        Center(
          child: SizedBox(
              height: widget.height,
              child: widget.showArrow == false
                  ? const SizedBox()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ...["back", "forward"].map((f) =>
                            Renderer(f == 'back' ? rendererKey1 : rendererKey2,
                                (updateRender, active) {
                              return Visibility(
                                visible: widget.allowWrap
                                    ? true
                                    : (f == 'back' &&
                                                widget.controller.page
                                                        ?.round() ==
                                                    0 ||
                                            f == 'forward' &&
                                                widget.controller.page
                                                        ?.round() ==
                                                    widget.children.length - 1
                                        ? false
                                        : true),
                                child: GestureDetector(
                                  onTapUp: (d) {
                                    scrollPosition(updateRender, function: f);
                                  },
                                  onTapDown: (d) {
                                    updateRender(true);
                                  },
                                  onLongPress: () {
                                    scrollPosition(updateRender, function: f);
                                  },
                                  child: Container(
                                    height: widget.height! / 2,
                                    width: 40.0,
                                    color: active
                                        ? const Color(0x77121212)
                                        : Colors.transparent,
                                    child: Icon(
                                      f == "back"
                                          ? Icons.arrow_back_ios
                                          : Icons.arrow_forward_ios,
                                      color: active
                                          ? Colors.white
                                          : widget.arrowColor ?? Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }))
                      ],
                    )),
        ),
        Center(
          child: widget.showIndicator != true
              ? const SizedBox()
              : Container(
                  height: widget.height,
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        width: widget.width,
                        alignment: Alignment.bottomCenter,
                        color: (widget.indicatorBackgroundColor ??
                                const Color(0xff121212))
                            .withOpacity(
                                widget.indicatorBackgroundOpacity ?? 0.5),
                        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                        child: Indicator(
                          indicatorName: widget.indicatorType,
                          selectedColor: widget.activeIndicatorColor,
                          unSelectedColor: widget.unActiveIndicatorColor,
                          totalPage: widget.children.length,
                          width: widget.width,
                          controller: widget.controller,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    ));
  }

  _getCarousel(ConnectisCarouselScrollCard widget) {
    dynamic carousel;
    dynamic type = widget.type.runtimeType == Types
        ? widget.type
        : _getType(widget.type.toLowerCase());

    switch (type) {
      case Types.simple:
        {
          carousel = SimpleCarousel(widget);
        }
        break;
      case Types.slideSwiper:
        {
          carousel = SlideSwipe(widget);
        }
        break;
    }
    return carousel;
  }
}

_getType(String type) {
  switch (type) {
    case "simple":
      return Types.simple;

    case "slideswiper":
      return Types.slideSwiper;
  }
}
