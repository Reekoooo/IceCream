import 'package:flutter/material.dart';
import 'package:flutter_ice_cream/assets/assets_provider.dart';
import 'package:flutter_ice_cream/ui_components/custom_circle.dart';
import 'package:flutter_ice_cream/ui_components/flare_animation.dart';
import 'package:flutter_ice_cream/ui_components/ice_cream_animation.dart';

class MenuWheel extends StatefulWidget {
  final Size screenSize;


  MenuWheel(
      {Key key,
        @required this.screenSize,
      })
      : super(key: key);

  @override
  _MenuWheelState createState() => _MenuWheelState();
}

class _MenuWheelState extends State<MenuWheel> with TickerProviderStateMixin {
  Animation<double> _incrementalRotationAnimation;
  Animation<double> _scaleDownAnimation;

  Animation<double> _menuFadeOutAnimation;
  Animation<double> _circularReveal;
  Animation<double> _circleFadeInAnimation;
  Animation<double> _textOpacityAnimation;
  //Animation<double> _flareSlideLeftAnimation;

  AnimationController _menuLeavingController;
  AnimationController _incremintalRotationAnimationController;
  Animation<double> _rotationAnimation;
  double _currentRotation = 0.0;
  bool _isButtonVisible = true;
  static const double _incrementalRotation = -0.25;

  Animation<double> _menuTranslationAnimation;
  Size screenSize;

  Animation<double> controller;

  @override
  void initState() {
    super.initState();


    _incremintalRotationAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 200))..addListener((){
      if (_currentRotation == -0.75) {
        _isButtonVisible = false;
        _menuLeavingController.forward();
      }
    });

    screenSize = widget.screenSize;
    _menuLeavingController =
    AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..addListener(() {
      });

    _incrementalRotationAnimation =Tween<double>(begin: _currentRotation,end: _currentRotation+_incrementalRotation).animate(

        CurvedAnimation(parent: _incremintalRotationAnimationController, curve: Curves.decelerate));

    _rotationAnimation =
        Tween<double>(begin: 3.14 / 4, end: 3.14 * 8 + 3.14 / 4).animate(
          CurvedAnimation(
              parent: _menuLeavingController, curve: Interval(0.4, 0.6, curve: Curves.linear)),
        );


    _menuTranslationAnimation =
    Tween<double>(begin: screenSize.height / 2, end: 0.0).animate(
      CurvedAnimation(
        parent: _menuLeavingController,
        curve: Interval(0.0, 0.1, curve: Curves.ease),
      ),
    )..addListener(() {
      setState(() {});
    });
    _scaleDownAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _menuLeavingController,
          curve: Interval(0.2, 0.3, curve: Curves.decelerate)),
    )..addListener(() {
      setState(() {});
    });

    _menuFadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _menuLeavingController, curve: Interval(0.6, 0.7, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {});
      });
    _circularReveal = Tween<double>(begin: 0.0, end: screenSize.height).animate(
        CurvedAnimation(parent: _menuLeavingController, curve: Interval(0.65, 0.7)))
      ..addListener(() {
        setState(() {});
      });
    _circleFadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _menuLeavingController,
            curve: Interval(0.65, 0.7, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {});
      });
    _textOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _menuLeavingController, curve: Interval(0.75, 1.0, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {});
      });
//    _flareSlideLeftAnimation = Tween(begin: screenSize.width, end: 0.0).animate(
//        CurvedAnimation(
//            parent: _menuLeavingController,
//            curve: Interval(0.7, 0.8, curve: Curves.bounceOut)))
//      ..addListener(() {
//        setState(() {});
//      });
  }

  @override
  void dispose() {
    _incremintalRotationAnimationController.dispose();
    _menuLeavingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Opacity(
            opacity: _circleFadeInAnimation.value,
            child: Container(
              child: CustomPaint(
                painter: DrawCircle(
                  context: context,
                  color: AssetsProvider.of(context).backgroundColor,
                  radius: _circularReveal.value,
                ),
              ),
            ),
          ),
        ),
        FlareAnimation(
          controller: _menuLeavingController,
          screenSize: screenSize,
        ),
        IceCreamAnimation(
          controller: _menuLeavingController,
          screenSize: screenSize,
        ),
        Opacity(
          opacity: _textOpacityAnimation.value,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 260.0),
              child: Text(
                "You are Awesome ..! ",
                style: TextStyle(fontSize: 50, color: Colors.white54),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _menuFadeOutAnimation,
          child: Transform.translate(
            offset: Offset(0.0, _menuTranslationAnimation.value),
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              alignment: FractionalOffset.center,
              child: Transform.scale(
                scale: _scaleDownAnimation.value,
                alignment: FractionalOffset.center,
                child: Center(
                  child: RotationTransition(
                      turns: _incrementalRotationAnimation,
                      child: AssetsProvider.of(context).menu),
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: _isButtonVisible
                  ? RaisedButton(
                color: AssetsProvider.of(context).backgroundColor,
                textColor: Colors.white70,
                child: Text("Click 3 times"),
                onPressed: _rotateToNext,
              )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }

  void _rotateToNext() {
    final double _endRotation = _currentRotation + _incrementalRotation;
    setState(() {
      _incrementalRotationAnimation =
          Tween(begin: _currentRotation, end: _endRotation).animate(
            CurvedAnimation(parent: _incremintalRotationAnimationController, curve: Curves.decelerate)
              ..addListener(() {
                setState(() {});
              }),
          );
    });

    _currentRotation = _endRotation;
    _incremintalRotationAnimationController.forward(from: 0.0);
  }
}