import 'package:flutter/material.dart';
import 'package:flutter_ice_cream/assets/assets_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Size screenSize;
  bool _isButtonVisible = true;

  AnimationController _animationController;
  AnimationController _menuLeavingController;
  Animation<double> _rotationAnimation;
  double _currentRotation = 0.0;
  static const double _incrementalRotation = -0.25;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _menuLeavingController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            print(_menuLeavingController.value);
            setState(() {});
          });

    _rotationAnimation = Tween(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
    )..addListener(() {
        if (_rotationAnimation.value == -0.75) {
          print("1 Rotation finished");
          _isButtonVisible = false;
          _menuLeavingController.forward();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _menuLeavingController.dispose();
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
          new MenuWheel(
            screenSize: screenSize,
            rotationAnimation: _rotationAnimation,
            controller: _menuLeavingController,
          ),
        ],
      ),
    );
  }

  void _rotateToNext() {
    final double _endRotation = _currentRotation + _incrementalRotation;
    setState(() {
      _rotationAnimation =
          Tween(begin: _currentRotation, end: _endRotation).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
      );
    });

    _currentRotation = _endRotation;
    print(_currentRotation);
    _animationController.forward(from: 0.0);
  }
}

class MenuWheel extends StatelessWidget {
  MenuWheel(
      {Key key,
      @required this.screenSize,
      @required Animation<double> rotationAnimation,
      @required this.controller})
      : _incrementalRotationAnimation = rotationAnimation,
        _menuTranslationAnimation =
            Tween<double>(begin: screenSize.height / 2, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.1, curve: Curves.ease),
          ),
        ),
        _scaleDownAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.2, 0.3, curve: Curves.decelerate)),
        ),
        _rotationAnimation =
            Tween<double>(begin: 3.14 / 4, end: 3.14 * 8 + 3.14 / 4).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.4, 0.6, curve: Curves.linear)),
        ),
        _menuFadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.6, 0.7, curve: Curves.easeIn))),
        _circularReveal = Tween<double>(begin: 0.0, end: screenSize.height)
            .animate(CurvedAnimation(
                parent: controller, curve: Interval(0.65, 0.7))),
        _circleFadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.65, 0.7, curve: Curves.easeIn))),
        _textOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.75, 1.0, curve: Curves.easeIn))),
        _flareSlideLeftAnimation = Tween(begin: screenSize.width, end: 0.0)
            .animate(
                CurvedAnimation(parent: controller, curve: Interval(0.7, 0.8,curve: Curves.bounceOut))),
        super(key: key);

  final Animation<double> controller;
  final Size screenSize;
  final Animation<double> _incrementalRotationAnimation;
  final Animation<double> _scaleDownAnimation;
  final Animation<double> _rotationAnimation;
  final Animation<double> _menuFadeOutAnimation;
  final Animation<double> _circularReveal;
  final Animation<double> _circleFadeInAnimation;
  final Animation<double> _textOpacityAnimation;
  final Animation<double> _flareSlideLeftAnimation;

  final Animation<double> _menuTranslationAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        Transform.translate(
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
      ],
    );
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
