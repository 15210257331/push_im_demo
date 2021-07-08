import 'dart:io';

import 'package:flutter/material.dart';
import 'package:push_im_demo/pages/conversation/message_types/file_message.dart';
import 'package:push_im_demo/pages/conversation/message_types/image_message.dart';
import 'package:push_im_demo/pages/conversation/message_types/sound_message.dart';
import 'package:push_im_demo/pages/conversation/message_types/text_message.dart';
import 'package:push_im_demo/pages/conversation/message_types/video_message.dart';
import 'package:push_im_demo/utils/date_utls.dart';
import 'package:tencent_im_sdk_plugin/enum/message_elem_type.dart';
import 'package:tencent_im_sdk_plugin/enum/message_status.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class MessageItemBody extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  const MessageItemBody({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _MessageBodyState createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageItemBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 12, left: 12, right: 12,),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 180),
        child: Column(
          crossAxisAlignment: widget.v2TimMessage.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            buildTime(),
            buildMessageItem(),
            buildReadState(),
          ],
        )
    );
  }

  Widget buildTime() {
    return Text(
      DateFormatUtils.timestampToLocalDateYMD(
          widget.v2TimMessage.timestamp),
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget buildMessageItem() {
    switch (widget.v2TimMessage.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return TextMessage(v2TimMessage: widget.v2TimMessage,);
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return ImageMessage(v2TimMessage: widget.v2TimMessage);
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return SoundMessage(v2TimMessage: widget.v2TimMessage);
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return VideoMessage(v2TimMessage: widget.v2TimMessage);
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        return FileMessage(v2TimMessage: widget.v2TimMessage);
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return TextMessage(v2TimMessage: widget.v2TimMessage);
      // case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
      //   return TextMessage(v2TimMessage: widget.v2TimMessage);
      default:
        return Container(
            height: 40,
            child: Text("未知消息类型")
        );
    }
  }

  Widget buildReadState() {
    Widget state;
    if (widget.v2TimMessage.status == MessageStatus.V2TIM_MSG_STATUS_SENDING) {
      state =  Text(
        "发送中...",
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey,
        ),
      );
    }
    if(widget.v2TimMessage.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC) {
      if(widget.v2TimMessage.isSelf) {
        if(widget.v2TimMessage.isPeerRead) {
          state = Text('已读',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          );
        } else {
          state = Text('未读',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          );
        }
      } else {
        state = Container();
      }
    }
    return state;
  }
}
