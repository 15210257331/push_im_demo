import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/widgets/empty.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class BlackList extends StatefulWidget {
  const BlackList({Key key}) : super(key: key);

  @override
  _BlackListState createState() => _BlackListState();
}

class _BlackListState extends State<BlackList> {

  List<V2TimFriendInfo> blackList = [];

  @override
  void initState() {
    super.initState();
    getBlackList();
  }

  getBlackList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getFriendshipManager()
        .getBlackList();
    if (res.code == 0) {
      List<V2TimFriendInfo> list = res.data;
      setState(() {
        blackList = list;
      });
    } else {
      print("获取黑名单失败 ${res.desc} ${res.code} ");
    }
  }

  deleteFromBlackList(String userId) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('黑名单', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: buildBlackList(),
      ),
    );
  }

  Widget buildBlackList() {
    return blackList.length > 0 ?
    ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            child: ListTile(
              title: Text(blackList[index].userProfile.nickName),
              trailing: GestureDetector(
                onTap: () async {
                  V2TimValueCallback<List<V2TimFriendOperationResult>> res =
                      await TencentImSDKPlugin.v2TIMManager
                      .getFriendshipManager()
                      .deleteFromBlackList(userIDList: [blackList[index].userID]
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
                },
                child: Icon(Icons.delete_forever),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
          );
        },
        itemCount: blackList.length
    ) :
    Empty();
  }
}
