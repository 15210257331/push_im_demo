import 'package:flutter/material.dart';
import 'package:push_im_demo/model/contact.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';


class ContactProvider with ChangeNotifier {

  // 联系人列表
  List<V2TimFriendInfo>  contactList = [];

  /// 获取好友列表
  loadFriendList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendList();
    if(res.code == 0) {
      contactList = res.data;
      notifyListeners();
      return contactList;
    }
  }

}
