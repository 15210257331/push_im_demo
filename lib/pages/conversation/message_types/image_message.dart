import 'dart:io';

import 'package:flutter/material.dart';
import 'package:push_im_demo/utils/date_utls.dart';
import 'package:push_im_demo/widgets/photo_view_gallery.dart';
import 'package:tencent_im_sdk_plugin/enum/message_status.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class ImageMessage extends StatefulWidget {
  final V2TimMessage v2TimMessage;

  const ImageMessage({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _ImageMessageState createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  /// 点击图片预览
  void imageView() async {
    FocusScope.of(context).unfocus();
    double initOpacity = 1.0;
    double resetInitOpacity(double animationValue) {
      initOpacity = 0.0;
      return animationValue;
    }

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return PhotoView(
            galleryList: [widget.v2TimMessage.imageElem.imageList[2]?.url]);
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return AnimatedOpacity(
          opacity: animation.value == initOpacity
              ? 0
              : resetInitOpacity(animation.value),
          child: child,
          duration: Duration(milliseconds: 200),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: imageView,
        child: Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4)),
            child: widget.v2TimMessage.imageElem.imageList[2]?.url != null
                ? Image.network(
              widget.v2TimMessage.imageElem.imageList[2]?.url,
            )
                : Image.file(
                new File(widget.v2TimMessage.imageElem.path)
            )
        ),
    );
  }


}
