import 'package:flutter/material.dart';

class AssetsProvider extends InheritedWidget{
  AssetsProvider({Key key,Widget child}):super(key: key,child: child);

  final Color backgroundColor = Color(0xff6C179D);

  final Image logo = Image.asset('assets/logo.png',);
  final Image menu = Image.asset('assets/menu.png',fit: BoxFit.cover,);
  final Image flare1 = Image.asset('assets/flare1.png',fit: BoxFit.cover,);
  final Image flare2 = Image.asset('assets/flare2.png',fit: BoxFit.cover,);
  final Image cone = Image.asset('assets/cone.png',fit: BoxFit.cover,width: 186,height: 485,);
  final Image ice = Image.asset('assets/ice.png',fit: BoxFit.cover,);
  final Image dipping = Image.asset('assets/dipping.png',fit: BoxFit.cover,);
  final Image topping = Image.asset('assets/toping.png',fit: BoxFit.cover,);


  static AssetsProvider of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AssetsProvider) as AssetsProvider;

  }
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

}