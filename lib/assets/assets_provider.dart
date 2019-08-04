import 'package:flutter/material.dart';



class AssetsProvider extends InheritedWidget{
  AssetsProvider({Key key,Widget child }):super(key: key,child: child);

  final Color backgroundColor = Color(0xff6C179D);

  final Image logo = Image.asset('assets/logo.png',);
  final Image menu = Image.asset('assets/menu.png',fit: BoxFit.cover,);
  final Image flare1 = Image.asset('assets/flare1.png',fit: BoxFit.cover,);
  final Image flare2 = Image.asset('assets/flare2.png',fit: BoxFit.cover,);
  final Image cone = Image.asset('assets/cone.png',fit: BoxFit.cover,);
  final Image ice = Image.asset('assets/ice.png',fit: BoxFit.cover,);
  final Image dipping = Image.asset('assets/dipping.png',fit: BoxFit.cover,);
  final Image topping = Image.asset('assets/topping.png',fit: BoxFit.cover,);

  Image getAsset(String assetName,{VoidCallback callback}){
    return Image.asset('assets/$assetName.png',fit: BoxFit.cover,
        frameBuilder : callback == null?null:(BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded){
          if(frame == null) { print('loading .......');
          }else{
            Future.delayed(Duration(),callback);
          }
          return child;
        }
    );
  }

  static AssetsProvider of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AssetsProvider) as AssetsProvider;

  }
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

}