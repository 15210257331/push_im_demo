import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class SoundMessage extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  const SoundMessage({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _SoundMessageState createState() => _SoundMessageState();
}

class _SoundMessageState extends State<SoundMessage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
