import 'package:flutter/material.dart';

class AssetsProvider extends InheritedWidget{
  AssetsProvider({Key key,Widget child}):super(key: key,child: child);

  final Color backgroundColor = Color(0xff6C179D);

  final Image logo = Image.asset('assets/logo.png',);
  final Image menu = Image.asset('assets/menu.png',fit: BoxFit.cover,);
  final Image flare1 = Image.asset('assets/flare1.png',fit: BoxFit.cover,);
  final Image flare2 = Image.asset('assets/flare2.png',fit: BoxFit.cover,);


  static AssetsProvider of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AssetsProvider) as AssetsProvider;

  }
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}