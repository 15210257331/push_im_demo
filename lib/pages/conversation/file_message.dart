import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class FileMessage extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  const FileMessage({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _FileMessageState createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
