import 'package:flutter/material.dart';
import 'package:flutter_ice_cream/assets/assets_provider.dart';

class FlareAnimation extends StatefulWidget {
  FlareAnimation({
    Key key,
    @required this.controller,
    @required this.screenSize,
  }) :
  //flareSlideLeftAnimation,
        super(key: key);
  final Animation<double> controller;
  final Size screenSize;

  @override
  _FlareAnimationState createState() => _FlareAnimationState();
}

class _FlareAnimationState extends State<FlareAnimation> {
  Animation<double> _flareSlideLeftAnimation;

  @override
  void initState() {
    super.initState();
    _flareSlideLeftAnimation = Tween(begin: widget.screenSize.width, end: 0.0)
        .animate(CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0.7, 0.8, curve: Curves.bounceOut)))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_flareSlideLeftAnimation.value, 0.0),
      child: Opacity(
        opacity: 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: AssetsProvider.of(context).flare1),
            Expanded(child: AssetsProvider.of(context).flare2),
          ],
        ),
      ),
    );
  }
}