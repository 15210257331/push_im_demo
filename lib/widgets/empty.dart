import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('空的，嘿嘿！'),
      ),
    );
  }
}
