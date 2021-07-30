import 'package:flutter/material.dart';

///头像处理类
class MyAvatar extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  final double padding;
  final BoxShape boxShape;
  final double radius;
  final Color boxBroadColor;

  MyAvatar(
      this.imgUrl, {
        this.width = 0,
        this.height = 0,
        this.padding = 0,
        this.boxShape = BoxShape.circle,
        this.radius = 0,
        this.boxBroadColor = Colors.white,
      });

  @override
  Widget build(BuildContext context) {

    String defaultUrl = 'https://p9.douyinpic.com/img/tos-cn-p-0015/a6a06c8a2a58422cacaae95009444f69~c5_300x400.jpeg?from=2563711402_large';

    _getChildWidget() {
      return boxShape == BoxShape.circle
          ? CircleAvatar(
        backgroundImage: NetworkImage(imgUrl?? defaultUrl),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          imgUrl?? defaultUrl,
          fit: BoxFit.cover,
        ),
      );
    }
    _getBorderRadius(){
      return boxShape == BoxShape.circle
          ? BoxDecoration(
        shape: boxShape,
        color: boxBroadColor,
      )
          : BoxDecoration(
        shape: boxShape,
        color: boxBroadColor,
        borderRadius: BorderRadius.circular(radius),
      );
    }
    return Container(
        width: width,
        height: height,
        child: _getChildWidget(),
        padding: EdgeInsets.all(padding),
        decoration:_getBorderRadius());
  }
}