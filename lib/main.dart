import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ice_cream/screens/screen_1.dart';

import 'assets/assets_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return AssetsProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Screen1() ,
      ),
    );
  }
}

