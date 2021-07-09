import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/pages/conversation/message_item_body.dart';
import 'package:push_im_demo/provider/conversation_provider.dart';
import 'package:push_im_demo/utils/file_utils.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ConversationDetail extends StatefulWidget {

  final String conversationID;

  const ConversationDetail({Key key, this.conversationID}) : super(key: key);

  @override
  _ConversationDetailState createState() => _ConversationDetailState();
}

class _ConversationDetailState extends State<ConversationDetail> with SingleTickerProviderStateMixin {

  TextEditingController inputController = TextEditingController();

  FocusNode focusNode = FocusNode();

  ScrollController scrollController = ScrollController(keepScrollOffset: false);

  bool isShowMoreAction = false;

  bool isShowEmojiSection = false;

  V2TimConversation conversationData;

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {

    });
    scrollController.addListener(() {
      // print(scrollController.offset);
      // if(scrollController.offset >= 0 && focusNode.hasFocus) {
      //   focusNode.unfocus();
      // }
    });
    focusNode.addListener(() {
      /// 输入框得到焦点
      if(focusNode.hasFocus) {
        scrollToBottom();
        setState(() {
          if(isShowMoreAction == true) {
            isShowMoreAction = false;
          }
          if(isShowEmojiSection == true) {
            isShowEmojiSection = false;
          }
        });
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
      setState(() {
        conversationData = res.data;
      });
      markC2CMessageAsRead();
      V2TimValueCallback<List<V2TimMessage>> rest = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getC2CHistoryMessageList(
        userID: conversationData?.userID,
        count: 30,
      );
      if(rest.code == 0) {
        List<V2TimMessage> list = rest.data;
        Provider.of<ConversationProvider>(context, listen: false).addMessages(conversationData.userID, list);
      }
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
    if(focusNode.hasFocus) {
      focusNode.unfocus();
    }
    setState(() {
      if(isShowEmojiSection == true) {
        isShowEmojiSection = false;
      }
      isShowMoreAction = true;
    });
  }

  /// 显示emoji区域
  void showEmoji() {
    if(focusNode.hasFocus) {
      focusNode.unfocus();
    }
    setState(() {
      if(isShowMoreAction == true) {
        isShowMoreAction = false;
      }
      isShowEmojiSection = true;
    });
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
      Provider.of<ConversationProvider>(context, listen: false).addOneMessageIfNotExits(conversationData.userID, res.data);
      setState(() {
        inputController.clear();
        scrollToBottom();
      });
    }
  }

  /// 发送图片消息
  sendImageMessage() async {
    File selectedImage = await FileUtils.getImage();
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendImageMessage(
      imagePath: selectedImage.path,
      receiver: conversationData.userID,
      groupID: "",
      // priority: priority,
      // onlineUserOnly: onlineUserOnly,
      // isExcludedFromUnreadCount: isExcludedFromUnreadCount,
    );
    if(res.code == 0) {
      Provider.of<ConversationProvider>(context, listen: false).addOneMessageIfNotExits(conversationData.userID, res.data);
      print("发送消息成功 消息状态${res.data.status}");
      setState(() {
        scrollToBottom();
      });
    }
  }

  /// 发送视频消息
  sendVideoMessage() async {
    File selectedVideo = await FileUtils.getVideo();
    if(selectedVideo == null) {
      return;
    }
    // 获取snapshotPath，type，duration
    String tempPath = (await getTemporaryDirectory()).path;
    /// 生成封面缩略图
    final fileName = await VideoThumbnail.thumbnailFile(
      video: selectedVideo.path,
      thumbnailPath: tempPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendVideoMessage(
      videoFilePath: selectedVideo.path,
      type: selectedVideo.path.split('.').last,
      snapshotPath: "$fileName",
      duration: 10,
      receiver: conversationData.userID,
      // groupID: groupID.length > 0 ? groupID.first : "",
      // priority: priority,
      // onlineUserOnly: onlineUserOnly,
      // isExcludedFromUnreadCount: isExcludedFromUnreadCount,
    );
    if(res.code == 0) {
      Provider.of<ConversationProvider>(context, listen: false).addOneMessageIfNotExits(conversationData.userID, res.data);
      setState(() {
        scrollToBottom();
      });
    }
  }

  /// 发送文件消息
  sendFileMessage() async {
    File selectedFile = await FileUtils.getSingleFile();
    if(selectedFile == null) {
      return;
    }
    V2TimValueCallback<V2TimMessage> res = await TencentImSDKPlugin
        .v2TIMManager.getMessageManager().sendFileMessage(
      fileName: selectedFile.path.split('/').last,
      filePath: selectedFile.path,
      receiver: conversationData.userID,
      // groupID: type == 2 ? toUser : null,
      // onlineUserOnly: false,
    );
    if (res.code == 0) {
      try {
        Provider.of<ConversationProvider>(context, listen: false)
            .addOneMessageIfNotExits(conversationData.userID, res.data);
        setState(() {
          scrollToBottom();
        });
      } catch (err) {
        EasyLoading.showError('发送失败');
      }
    } else {
      // User canceled the picker
    }
  }

  Future audioVideoCall() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('语音通话',textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '拍照');
                  },
                ),
                ListTile(
                  title: Text('视频通话',textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '从相册选择');
                  },
                ),
                ListTile(
                  title: Text('取消',textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '取消');
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios,color: Colors.white),
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
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.white,
        // brightness: Brightness.light,
      ),
      body: GestureDetector(
        onTap: () {
          /// 点击空白 如果键盘弹出收起键盘 如果更多区域弹出隐藏 如果emoji 弹出 隐藏
          if(focusNode.hasFocus) {
            focusNode.unfocus();
          } else if(isShowMoreAction == true) {
            setState(() {
              isShowMoreAction = false;
            });
          } else if(isShowEmojiSection == true) {
            setState(() {
              isShowEmojiSection = false;
            });
          }
        },
        child: Container(
          color: Color(0xFFf4f4f4),
          height: double.infinity,
          child: Column(
            children: [
              buildChatBody(),
              buildAction(),
              buildMoreAction(),
              buildEmojiSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建消息列表区
  Widget buildChatBody() {
    return Consumer<ConversationProvider>(builder: (context, conversationProvider, _) {
      List<V2TimMessage> messageList = [];
      if(conversationData != null && conversationProvider.allMessageMap.containsKey(conversationData.userID)) {
         messageList = conversationProvider.allMessageMap[conversationData.userID];
      }
      return Expanded(
        child:ListView.builder(
          reverse: true,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
          itemCount: messageList.length,
          controller: scrollController,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: messageList[index].isSelf ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: messageList[index].faceUrl == null || messageList[index].faceUrl == '' ? AssetImage('assets/images/avatar.png') : NetworkImage(messageList[index].faceUrl),
                  ),
                  MessageItemBody(v2TimMessage:messageList[index]),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  /// 构建底部操作区域
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
              showEmoji();
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

  /// 构建表情选择区域
  Widget buildEmojiSection() {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("assets/json/emoji.json"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = json.decode(snapshot.data.toString());
            return Stack(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.linear,
                  height: isShowEmojiSection ? 260 : 0,
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: GridView.custom(
                    padding: EdgeInsets.all(3),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      mainAxisSpacing: 0.5,
                      crossAxisSpacing: 6.0,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate((context, index) {
                      return GestureDetector(
                        onTap: () {
                          String value = inputController.value.text +  String.fromCharCode(data[index]["unicode"]);
                          inputController.text = value;
                          setState(() {});
                        },
                        child: Center(
                          child: Text(
                            String.fromCharCode(data[index]["unicode"]),
                            style: TextStyle(fontSize: 33),
                          ),
                        ),
                      );
                    },
                      childCount: data.length,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    right: 30,
                    child: ElevatedButton(
                        onPressed: () {
                          sendTextMessage();
                        },
                        child: Text('发送',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        ),
                    ),
                )
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  ///  构建更多操作区域
  Widget buildMoreAction() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
      ),
      height: isShowMoreAction ? 240 : 0,
      padding: EdgeInsets.only(left: 20,right: 20, top: 10),
      width: double.infinity,
      child: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100, //根据maxCrossAxisExtent的值对比屏幕的真实宽度，决定一行或者一列显示多少个Item
              mainAxisExtent: 100, // 每个item 的高度
              mainAxisSpacing: 15,
              crossAxisSpacing: 10
        ),
        children: <Widget>[
          buildMoreActionItem(title: 'picture', icon: Icons.picture_in_picture_outlined, onTap: sendImageMessage),
          buildMoreActionItem(title: 'video', icon: Icons.video_call_sharp, onTap: sendVideoMessage),
          buildMoreActionItem(title: 'file', icon: Icons.file_copy_rounded, onTap: sendFileMessage),
          buildMoreActionItem(title: 'audio', icon: Icons.keyboard_voice_sharp),
          buildMoreActionItem(title: '音视频', icon: Icons.featured_video_outlined,onTap: audioVideoCall),
        ],
      ),
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
