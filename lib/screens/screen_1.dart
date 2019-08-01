import 'package:flutter/material.dart';
import 'package:flutter_ice_cream/assets/assets_provider.dart';
import 'package:flutter_ice_cream/routes_transitions/disolve_route.dart';

import 'home_screen.dart';

const String _display = 'Welcome';
const String _body =
    'This ice cream is special. It does not exist in the frozen food section. You cannot find it in your local parlor. No. Everything about this ice cream—the flavor, mix-ins, packaging, even the name—has been created by you and churned fresh by our award-winning team of artists. Just as personal as a set of monogrammed towels. But so much sweeter.';
const String _buttonText = 'Tap to begin ..';
const Color _filterColor = Color(0xff3C177D);
const Color _buttonColor = Color(0xff933FC3);
class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        );
    return Material(
      child: Container(
        decoration: BoxDecoration(
//          color: _filterColor.withOpacity(0.5),
          color: _filterColor.withOpacity(1),
          image: DecorationImage(
            image: AssetImage('assets/first_page_background.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(_filterColor.withOpacity(0.4),BlendMode.dstATop  )

          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AssetsProvider.of(context).logo,
            //Image.asset('assets/logo.png'),
            SizedBox(height: 16.0,),
            Text(
              _display,
              style: newTextTheme.display2,
            ),
            SizedBox(height: 16.0,),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Text(
                  _body,
                  style: newTextTheme.body1.copyWith(fontSize: 12.0,letterSpacing: 1.0),
                ),
              ),
            ),
            SizedBox(height: 32.0,),
            RaisedButton(
              color: _buttonColor,
              child: Text(_buttonText,style: newTextTheme.body1.copyWith(fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).push(DissolveRoute(
                  page: HomeScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
