import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/pages/conversation/conversation_detail.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class FriendInfo extends StatefulWidget {

  final String userID;

  const FriendInfo({Key key, this.userID}) : super(key: key);

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<FriendInfo> {

  V2TimFriendInfo friendInfo;

  bool isBlacklist = false;

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
        trailing: Switch(
            value: this.isBlacklist,
            activeColor: Colors.red,
            onChanged: (value) async {
              setState(() {
                this.isBlacklist = value;
              });
              if(this.isBlacklist) {
                V2TimValueCallback<List<V2TimFriendOperationResult>> res = await TencentImSDKPlugin.v2TIMManager
                    .getFriendshipManager()
                    .addToBlackList(userIDList: [friendInfo.userID]);
                if(res.code == 0) {
                  List<V2TimFriendOperationResult> opres = res.data;
                  if (opres[0].resultCode == 0) {
                    EasyLoading.showSuccess('操作成功');
                    Provider.of<ContactProvider>(context, listen: false).loadFriendList();
                  } else {
                    EasyLoading.showError('操作失败');
                  }
                }
              } else {
                V2TimValueCallback<List<V2TimFriendOperationResult>> res =
                await TencentImSDKPlugin.v2TIMManager
                    .getFriendshipManager()
                    .deleteFromBlackList(userIDList: [friendInfo.userID]
                );
                if (res.code == 0) {
                  List<V2TimFriendOperationResult> opres = res.data;
                  print("黑名单返回${opres[0].resultCode}");
                  if (opres[0].resultCode == 0) {
                    EasyLoading.showSuccess('操作成功');
                    Provider.of<ContactProvider>(context, listen: false).loadFriendList();
                  } else {
                    EasyLoading.showError('操作失败');
                  }
                }
              }
            },
        ),
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
        onPressed: () async {
          V2TimValueCallback<List<V2TimFriendOperationResult>> res =
              await TencentImSDKPlugin.v2TIMManager
              .getFriendshipManager()
              .deleteFromFriendList(
            userIDList: [friendInfo.userID],
            deleteType: 2, //双向好友
          );
          if (res.code == 0) {
            // 删除成功
            EasyLoading.showSuccess('删除成功');
            Provider.of<ContactProvider>(context, listen: false).loadFriendList();
            Navigator.pop(context);
          }
          // Navigator.of(context).pop();
        },
      ),
    );
  }
}
