import 'package:flutter/material.dart';

typedef OnCall = Function(bool);
typedef Builder = Widget Function(OnCall rebuild, bool active);

class Renderer extends StatefulWidget {
  final Builder builder;
  @override
  final Key key;
  const Renderer(this.key, this.builder) : super(key: key);

  @override
  RendererState createState() => RendererState();
}

class RendererState extends State<Renderer> {
  late int data;
  late bool active;

  @override
  initState() {
    super.initState();
    active = false;
  }

  updateRenderer(bool status, [String? a]) {
    setState(() {
      active = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(updateRenderer, active);
  }
}
