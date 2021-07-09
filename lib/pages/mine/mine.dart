import 'package:flutter/material.dart';
import 'package:push_im_demo/widgets/loading.dart';

class Mine extends StatefulWidget {
  const Mine({Key key}) : super(key: key);

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFf4f4f4),
        width: double.infinity,
        child: Container(
          child: MyLoading(),
        ),
      ),
    );
  }
}
