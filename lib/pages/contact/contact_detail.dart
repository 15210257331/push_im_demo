import 'package:flutter/material.dart';
import 'package:push_im_demo/pages/conversation/conversation_detail.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class ContactDetail extends StatefulWidget {

  final String userID;

  const ContactDetail({Key key, this.userID}) : super(key: key);

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
      userIDList: [widget.userID],
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
        // backgroundColor: Colors.blueAccent,
        title: Text('联系人'),
        brightness: Brightness.dark,
      ),
      body: Container(
        color: Color(0xFFf4f4f4),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildInfo(),
            buildItem(),
            buildRemark(),
            buildSend(),
            buildDelete()
          ],
        ),
      ),
    );
  }

  Widget buildInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: friendInfo?.userProfile?.faceUrl == null ||
                friendInfo?.userProfile?.faceUrl == ''
                ? AssetImage('assets/images/avatar.png')
                : NetworkImage(friendInfo?.userProfile?.faceUrl),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(friendInfo?.userProfile?.nickName ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 26
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text('用户ID：${friendInfo?.userProfile?.userID}'),
              SizedBox(
                height: 5,
              ),
              Text('个性签名：${friendInfo?.userProfile?.selfSignature}'),
            ],
          )
        ],
      ),
    );
  }

  Widget buildItem() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text('加入黑名单'),
        trailing: Switch(value: false, onChanged: (_) => {}),
      ),
    );
  }

  Widget buildRemark() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text('备注'),
        trailing: Text(friendInfo?.friendRemark == '' || friendInfo?.friendRemark == null ? '暂无备注' : friendInfo?.friendRemark),
      ),
    );
  }

  Widget buildSend() {
    return Container(
      margin: EdgeInsets.only(
        left: 10, right: 10, bottom: 10
      ),
      width: double.infinity,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
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
              builder: (context) => ConversationDetail(conversationID: 'c2c_${widget.userID}',)
          ));
          // Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget buildDelete() {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: 10, bottom: 10
      ),
      width: double.infinity,
      child: FlatButton(
        color: Colors.red,
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        child: Text(
          '删除好友',
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ConversationDetail(conversationID: 'c2c_${widget.userID}',)
          ));
          // Navigator.of(context).pop();
        },
      ),
    );
  }
}
