import 'package:flutter/material.dart';
import 'package:push_im_demo/pages/conversation/conversation_detail.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class ContactDetail extends StatefulWidget {

  final List<String> userIDList;

  const ContactDetail({Key key, this.userIDList}) : super(key: key);

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {

  V2TimFriendInfo friendInfo;

  @override
  void initState() {
    super.initState();
    getFriendsInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 获取联系人信息
  getFriendsInfo() async {
    V2TimValueCallback<List<V2TimFriendInfoResult>> res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendsInfo(
      userIDList: widget.userIDList,
    );
    if(res.code == 0) {
      setState(() {
        friendInfo = res.data[0].friendInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text('联系人'),
        brightness: Brightness.dark,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(friendInfo?.userProfile?.faceUrl?? ''),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Text(friendInfo?.userProfile?.nickName),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Text(friendInfo?.userProfile?.userID),
            ),
            buildSend()
          ],
        ),
      ),
    );
  }

  Widget buildSend() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: Colors.red,
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        child: Text(
          '发送消息',
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ConversationDetail(conversationID: '',)
          ));
          // Navigator.of(context).pop();
        },
      ),
    );
  }
}
