import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ice_cream/assets/assets_provider.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Size screenSize;


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print(screenSize.height);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new MenuWheel(
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }
}

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
  Animation<double> _flareSlideLeftAnimation;

  AnimationController _menuLeavingController;
  AnimationController _animationController;
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


    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 200))..addListener((){
      print(_animationController.value);
      if (_currentRotation == -0.75) {
        print("1 Rotation finished");
        _isButtonVisible = false;
        _menuLeavingController.forward();
      }
    });

    screenSize = widget.screenSize;
    _menuLeavingController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            print(_menuLeavingController.value);
//            setState(() {});
          });

    controller = _menuLeavingController;

    _incrementalRotationAnimation =Tween<double>(begin: _currentRotation,end: _currentRotation+_incrementalRotation).animate(

    CurvedAnimation(parent: _animationController, curve: Curves.decelerate));

    _rotationAnimation =
        Tween<double>(begin: 3.14 / 4, end: 3.14 * 8 + 3.14 / 4).animate(
      CurvedAnimation(
          parent: controller, curve: Interval(0.4, 0.6, curve: Curves.linear))
        ..addListener(() {}),
    );


    _menuTranslationAnimation =
        Tween<double>(begin: screenSize.height / 2, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.1, curve: Curves.ease),
      ),
    )..addListener(() {
            setState(() {});
          });
    _scaleDownAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
          parent: controller,
          curve: Interval(0.2, 0.3, curve: Curves.decelerate)),
    )..addListener(() {
        setState(() {});
      });

    _menuFadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.6, 0.7, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {});
      });
    _circularReveal = Tween<double>(begin: 0.0, end: screenSize.height).animate(
        CurvedAnimation(parent: controller, curve: Interval(0.65, 0.7)))
      ..addListener(() {
        setState(() {});
      });
    _circleFadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.65, 0.7, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {});
      });
    _textOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.75, 1.0, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {});
      });
    _flareSlideLeftAnimation = Tween(begin: screenSize.width, end: 0.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 0.8, curve: Curves.bounceOut)))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
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
          controller: controller,
          screenSize: screenSize,
        ),
        IceCreamAnimation(
          controller: controller,
          screenSize: screenSize,
        ),
        Opacity(
          opacity: _textOpacityAnimation.value,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
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
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate)
          ..addListener(() {
            setState(() {});
          }),
      );
    });

    _currentRotation = _endRotation;
    print(_currentRotation);
    _animationController.forward(from: 0.0);
  }
}

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

class IceCreamAnimation extends StatefulWidget {
  const IceCreamAnimation(
      {Key key, @required this.controller, @required this.screenSize})
      : super(key: key);

  final Animation<double> controller;
  final Size screenSize;

  @override
  _IceCreamAnimationState createState() => _IceCreamAnimationState();
}

class _IceCreamAnimationState extends State<IceCreamAnimation> {
  GlobalKey _keyCone, _keyDipping, _keyTopping, _keyIce;
  double _coneHeight, _dippingWidth, _toppingHeight, _iceWidth;
  Size _screenSize;

  Animation<double> _controller;
  Animation<double> _dippingSlideLeftAnimation;
  Animation<double> _iceSlideRightAnimation;
  Animation<double> _toppingSlideDownAnimation;
  Animation<double> _coneSlideUpAnimation;

  final double _scale = 0.8;
  double _scaleFactor;

  @override
  void initState() {
    super.initState();
    _keyCone = GlobalKey();
    _keyDipping = GlobalKey();
    _keyTopping = GlobalKey();
    _keyIce = GlobalKey();

    _dippingWidth = 0.0;
    _iceWidth = 0.0;
    _coneHeight = 0.0;
    _toppingHeight = 0.0;
    _scaleFactor = 2 - _scale;

    _controller = widget.controller;
    _screenSize = widget.screenSize;

    SchedulerBinding.instance.addPostFrameCallback(_calculateDimensions);

    _dippingSlideLeftAnimation =
        Tween(begin: ((_screenSize.width / 2) + (_dippingWidth / 4)), end: 0.0)
            .animate(CurvedAnimation(
                parent: _controller,
                curve: Interval(0.8, 0.9, curve: Curves.bounceOut))
              ..addListener(() {
                setState(() {});
              }));
    _iceSlideRightAnimation =
        Tween(begin: (-(_screenSize.width / 2) - (_iceWidth / 4)), end: 0.0)
            .animate(CurvedAnimation(
                parent: _controller,
                curve: Interval(0.8, 0.9, curve: Curves.bounceOut)))
              ..addListener(() {
                setState(() {});
              });
    _toppingSlideDownAnimation =
        Tween(begin: -_screenSize.height / 2.0, end: -150.0 * _scaleFactor)
            .animate(CurvedAnimation(
                parent: _controller,
                curve: Interval(0.8, 0.9, curve: Curves.bounceOut)))
              ..addListener(() {
                setState(() {});
              });
    _coneSlideUpAnimation =
        Tween(begin: (_coneHeight / 4), end: 100.0 * _scaleFactor).animate(
            CurvedAnimation(
                parent: _controller,
                curve: Interval(0.8, 0.9, curve: Curves.bounceOut)))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: Center(
        child: Stack(
          fit: StackFit.loose,
          //overflow: Overflow.visible,
          //alignment: FractionalOffset.center,
          children: <Widget>[
            Transform.translate(
                offset: Offset(0.0, _coneSlideUpAnimation.value * _scaleFactor),
                child: Align(
                    key: _keyCone,
                    alignment: FractionalOffset.center,
                    child: AssetsProvider.of(context).cone)),
            Transform.translate(
                offset: Offset(
                    _iceSlideRightAnimation.value * _scaleFactor, -150.0),
                child: Container(
                    key: _keyIce,
                    child: Center(child: AssetsProvider.of(context).ice))),
            Transform.translate(
                offset: Offset(
                    _dippingSlideLeftAnimation.value * _scaleFactor, -190.0),
                child: Container(
                    key: _keyDipping,
                    child: Center(child: AssetsProvider.of(context).dipping))),
            Transform.translate(
                offset: Offset(
                    0.0, _toppingSlideDownAnimation.value * _scaleFactor),
                child: Container(
                  key: _keyTopping,
                  child: Center(
                      child: Image.asset(
                    'assets/toping.png',
                    fit: BoxFit.cover,
                  )),
                )) //AssetsProvider.of(context).topping))),
          ],
        ),
      ),
    );
  }

  void _calculateDimensions(_) {
    final RenderBox renderBoxCone = _keyCone.currentContext.findRenderObject();
    final RenderBox renderBoxIce = _keyIce.currentContext.findRenderObject();
    final RenderBox renderBoxDipping =
        _keyDipping.currentContext.findRenderObject();
    final RenderBox renderBoxTopping =
        _keyTopping.currentContext.findRenderObject();
    setState(() {
      _coneHeight = renderBoxCone.size.height;
      _toppingHeight = renderBoxTopping.size.height;
      _dippingWidth = renderBoxDipping.size.width;
      _iceWidth = renderBoxIce.size.width;

      print(
          "Cone Height = ${renderBoxCone.size.height}, Toping Height = $_toppingHeight ,Ice Width = $_iceWidth ,dipping Width = $_dippingWidth");

      _coneSlideUpAnimation = Tween(
              begin: (_screenSize.height / 2 + _coneHeight / 4),
              end: 100.0 * _scale)
          .animate(CurvedAnimation(
              parent: _controller,
              curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));

      _dippingSlideLeftAnimation = Tween(
              begin: (_screenSize.width / 2.0) + (_dippingWidth / 4.0),
              end: 0.0)
          .animate(CurvedAnimation(
              parent: _controller,
              curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));
      _iceSlideRightAnimation =
          Tween(begin: -(_screenSize.width / 2.0) - (_iceWidth / 4), end: 0.0)
              .animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));
      _toppingSlideDownAnimation =
          Tween(begin: -(_screenSize.height / 2.0) - 50.0, end: -150.0 * _scale)
              .animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));
    });
  }
}

class DrawCircle extends CustomPainter {
  final BuildContext context;
  final Offset center;

  final double radius;
  final Color color;
  Paint _paint;

  DrawCircle(
      {@required this.context,
      this.center = Offset.zero,
      this.radius = 100.0,
      this.color = Colors.red}) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
