import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/enum/message_elem_type.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class MessageItemDetail extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  MessageItemDetail({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _MessageItemDetailState createState() => _MessageItemDetailState();
}

class _MessageItemDetailState extends State<MessageItemDetail> {
  @override
  Widget build(BuildContext context) {
    switch (widget.v2TimMessage.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return buildTextDetail();
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return buildImgDetail();
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return buildImgDetail();
      default:
        return Container(height: 40, child: Center(child: Text("MsgBodyTypeError")));
    }
  }

  Widget buildTextDetail() {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
      margin: EdgeInsets.only(left: 12, right: 12, top: 5),
      padding: EdgeInsets.only(left:10,right: 10, bottom: 8,top:8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff7357FF)
      ),
      child: Text(widget.v2TimMessage.textElem.text,
        overflow: TextOverflow.ellipsis,
        maxLines: 500,
        style: TextStyle(
            color: Colors.white,
            fontSize: 17
        ),
      ),
    );
  }

  Widget buildImgDetail() {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
      margin: EdgeInsets.only(bottom: 12, left: 12, right: 12,),
      child: Image(
        image: NetworkImage(widget.v2TimMessage.imageElem.imageList[1]?.url,),
      ) ,
    );
  }
}
