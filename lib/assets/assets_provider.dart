import 'package:flutter/material.dart';

class AssetsProvider extends InheritedWidget{
  AssetsProvider({Key key,Widget child}):super(key: key,child: child);

  final Image logo = Image.asset('assets/logo.png');


  static AssetsProvider of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AssetsProvider) as AssetsProvider;

  }
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}