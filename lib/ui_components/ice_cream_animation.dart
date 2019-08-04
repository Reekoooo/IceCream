import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ice_cream/assets/assets_provider.dart';

class IceCreamAnimation extends StatefulWidget {
  const IceCreamAnimation({Key key, @required this.controller, @required this.screenSize})
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
  Animation<double> _opacityAnimation;
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

    _buildAnimations();

  }

  @override
  Widget build(BuildContext context) {

    return Opacity(
      opacity: _opacityAnimation.value,
      child: Transform.scale(
        scale: _scale,
        child: Center(
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(0.0, _coneSlideUpAnimation.value * _scaleFactor),
                child: Center(
                  child: Container(
                      key: _keyCone,
                      child: AssetsProvider.of(context).getAsset('cone',callback:  _calculateDimensions)

                  ),
                ),
              ),
              Transform.translate(
                  offset: Offset( _iceSlideRightAnimation.value * _scaleFactor, -150.0),
                  child: Center(
                    child: Container(
                        key: _keyIce,
                        child: AssetsProvider.of(context).getAsset('ice',)),
                  )),
              Transform.translate(
                  offset: Offset( _dippingSlideLeftAnimation.value * _scaleFactor, -190.0),
                  child: Center(
                    child: Container(
                        key: _keyDipping,
                        child:  AssetsProvider.of(context).getAsset('dipping',)),
                  )),
              Transform.translate(
                  offset: Offset(0.0, _toppingSlideDownAnimation.value * _scaleFactor),
                  child: Center(
                    child: Container(
                      key: _keyTopping,
                      child: AssetsProvider.of(context).getAsset('topping',),
                    ),
                  )) //AssetsProvider.of(context).topping))),
            ],
          ),
        ),
      ),
    );
  }


  FutureOr<dynamic> _calculateDimensions (){
    final RenderBox renderBoxCone = _keyCone.currentContext.findRenderObject();
    final RenderBox renderBoxTopping = _keyTopping.currentContext.findRenderObject();
    final RenderBox renderBoxIce = _keyIce.currentContext.findRenderObject();
    final RenderBox renderBoxDipping = _keyDipping.currentContext.findRenderObject();
    _coneHeight = renderBoxCone.size.height;
    _toppingHeight = renderBoxTopping.size.height;
    _dippingWidth = renderBoxDipping.size.width;
    _iceWidth = renderBoxIce.size.width;

    print('''
    Cone height = $_coneHeight 
    Topping height = $_toppingHeight
    Dipping width =  $_dippingWidth
    Ice width =  $_iceWidth
    
    ''');


    _buildAnimations();

  }

  void _buildAnimations() {
    _opacityAnimation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller, curve:
    Interval(0.75, 0.79 ,curve: Curves.linear)))
      ..addListener((){
        setState(() {

        });
      });

    _coneSlideUpAnimation =
        Tween(begin: (_screenSize.height / 2 + _coneHeight/ 4 ),
            end: 100.0 * _scale)
            .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.8 , 0.9 , curve: Curves.bounceOut)));

    _dippingSlideLeftAnimation =
        Tween( begin: (_screenSize.width / 2.0) + (_dippingWidth / 4.0),end: 0.0)
            .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));
    _iceSlideRightAnimation =
        Tween(begin: -(_screenSize.width / 2.0) - (_iceWidth / 4), end: 0.0)
            .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));
    _toppingSlideDownAnimation =
        Tween(begin: -(_screenSize.height / 2.0) -(_toppingHeight/4), end: -170.0 * _scale)
            .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.8, 0.9, curve: Curves.bounceOut)));
  }


}
