import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/conversation/message_item_detail.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class ConversationDetail extends StatefulWidget {

  final String conversationID;

  const ConversationDetail({Key key, this.conversationID}) : super(key: key);

  @override
  _ConversationDetailState createState() => _ConversationDetailState();
}

class _ConversationDetailState extends State<ConversationDetail> {

  TextEditingController inputController = TextEditingController();

  FocusNode focusNode = FocusNode();

  ScrollController scrollController = ScrollController(keepScrollOffset: false);

  /// 更多操作的高度监听
  ValueNotifier<double> valueNotifier = ValueNotifier(0);

  V2TimConversation conversationData;

  List<V2TimMessage> messageList = [];

  File image;

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {

    });
    scrollController.addListener(() {
      // if(focusNode.hasFocus) {
      // focusNode.unfocus();
      // }
    });
    focusNode.addListener(() {
      /// 输入框得到焦点
      if(focusNode.hasFocus) {
        scrollToBottom();
      }
    });
    getC2CHistoryMessageList();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    inputController.dispose();
    scrollController.dispose();
  }

  /// 获取历史消息记录
  getC2CHistoryMessageList() async {
    V2TimValueCallback<V2TimConversation> res = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getConversation(
      conversationID: widget.conversationID,
    );
    if(res.data != null) {
      conversationData = res.data;
      markC2CMessageAsRead();
      V2TimValueCallback<List<V2TimMessage>> rest = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getC2CHistoryMessageList(
        userID: conversationData?.userID,
        count: 20,
      );
      setState(() {
        messageList = rest.data;
      });
    }
  }

  /// 设置单聊消息已读
  markC2CMessageAsRead() async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .markC2CMessageAsRead(
      userID: conversationData?.userID,
    );
  }


  /// 消息内容滚动到最下边
  scrollToBottom() {
    scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
  }

  /// 显示更多操作区域
  void showMoreAction() {
    valueNotifier.value = 220.00;
  }

  /// 发送文本消息
  Future<void> sendTextMessage() async {
    String text = inputController.value.text;
    if(text.isEmpty) {
      return;
    }
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager.sendC2CTextMessage(
      text: text,
      userID: conversationData.userID,
    );
    if(res.code == 0) {
      setState(() {
        inputController.clear();
        messageList.insert(0,res.data);
        scrollToBottom();
      });
    }
  }

  /// 发送图片消息
  sendImageMessage() async {
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendImageMessage(
      imagePath: image.path,
      receiver: conversationData.userID,
      groupID: "",
      // priority: priority,
      // onlineUserOnly: onlineUserOnly,
      // isExcludedFromUnreadCount: isExcludedFromUnreadCount,
    );
    if(res.code == 0) {
      setState(() {
        messageList.insert(0,res.data);
        scrollToBottom();
      });
    }
  }

  Future getImage() async {
    await [Permission.camera,].request();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    print(statuses[Permission.camera]);
    final PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        sendImageMessage();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios,color: Color(0xFF333333)),
          onPressed: () {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
            }
            Navigator.of(context).pop();
          }
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(conversationData?.showName ?? '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: GestureDetector(
        onTap: () {
          if(focusNode.hasFocus) {
            /// 点击空白收起键盘
            focusNode.unfocus();
          } else {
            valueNotifier.value = 0;
          }
        },
        child: Container(
          color: Color(0xFFf4f4f4),
          height: double.infinity,
          child: Column(
            children: [
              buildChatBody(),
              buildAction(),
              buildMoreAction()
            ],
          ),
        ),
      ),
    );
  }

  /// 构建消息列表区
  Widget buildChatBody() {
    return Expanded(
      child:ListView.builder(
        reverse: true,
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
        itemCount: messageList.length,
        controller: scrollController,
        itemBuilder: (context, index) {
         if(messageList[index].isSelf == true) {
           return Container(
             margin: EdgeInsets.only(top: 10,bottom: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.end,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 MessageItemDetail(v2TimMessage:messageList[index]),
                 CircleAvatar(
                   radius: 23,
                   backgroundImage: NetworkImage(messageList[index].faceUrl),
                 ),
               ],
             ),
           );
         } else {
           return Container(
             margin: EdgeInsets.only(top: 10,bottom: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 CircleAvatar(
                   radius: 23,
                   backgroundImage: NetworkImage(conversationData?.faceUrl),
                 ),
                 MessageItemDetail(v2TimMessage:messageList[index]),
               ],
             ),
           );
         }
        },
      ),
    );
  }

  /// 构建底部区域
  Widget buildAction() {
    return Container(
      height: 90,
      padding: EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: Color(0xFFEBEBEB),
        border: Border(
            top: BorderSide(
                color: Color(0xFFEBEBEB),
                width: 1
            )
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                focusNode: focusNode,
                onEditingComplete: sendTextMessage,
                textInputAction: TextInputAction.send,
                scrollPadding: EdgeInsets.all(0.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  // hintText: 'Aa', //L.of(context).inputTips,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                //maxLines: 10,
                controller: inputController,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showMoreAction();
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Icon(Icons.emoji_emotions,
                size: 38,
                color: Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showMoreAction();
            },
            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Icon(Icons.add_circle_outline_outlined,
                size: 38,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///  构建更多操作区域
  Widget buildMoreAction() {
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (BuildContext context, double value, Widget child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
             ),
            ),
            height: value,
            padding: EdgeInsets.only(left: 20,right: 20, top: 10),
            width: double.infinity,
            child: Wrap(
              spacing: 25.0, // 主轴(水平)方向间距
              runSpacing: 10.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.spaceBetween, //沿主轴方向居中
              children: <Widget>[
                buildMoreActionItem(title: 'picture', icon: Icons.picture_in_picture_outlined, onTap: getImage),
                buildMoreActionItem(title: 'video', icon: Icons.video_call_sharp),
                buildMoreActionItem(title: 'file', icon: Icons.file_copy_rounded),
                buildMoreActionItem(title: 'audio', icon: Icons.keyboard_voice_sharp),
                buildMoreActionItem(title: 'location', icon: Icons.wrong_location_sharp),
              ],
            ),
          );
        }
    );
  }

  Widget buildMoreActionItem({String title, IconData icon, Function onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 60,
            height: 60,
            child: Icon(icon,
              size: 30,
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(title),
        )
      ],
    );
  }
}
