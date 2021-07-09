import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({Key key}) : super(key: key);

  @override
  _MyLoadingState createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (5)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/json/loading-spinner-lottie.json',
          controller: _controller,
          repeat: true,
          height: MediaQuery.of(context).size.height * 1,
          animate: true,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() {
                print('动画完成');
              });
          },
        ),
      ),
    );
  }
}
