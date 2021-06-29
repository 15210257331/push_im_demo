import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class TextMessage extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  const TextMessage({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _TextMessageState createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
      margin: EdgeInsets.only(left: 12, right: 12, top: 5),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xff7357FF)),
      child: Text(
        widget.v2TimMessage.textElem.text,
        overflow: TextOverflow.ellipsis,
        maxLines: 500,
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}
