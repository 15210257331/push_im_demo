import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/home.dart';
import 'package:push_im_demo/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (3)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        'assets/json/flying-rocket-lottie.json',
        controller: _controller,
        height: MediaQuery.of(context).size.height * 1,
        animate: true,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward().whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return Global.userInfo != null ? Home() : Login();
              }
              ),
            ));
        },
      ),
    );
  }
}