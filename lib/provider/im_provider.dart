import 'package:flutter/material.dart';
import 'package:push_im_demo/config.dart';
import 'package:push_im_demo/utils/storage.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_change_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_change_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_receipt.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class ImProvider with ChangeNotifier {
  List<V2TimMessage> messageList = [];

  /// 获取历史消息记录
  Future getC2CHistoryMessageList(String userID) async {
    V2TimValueCallback<List<V2TimMessage>> rest = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .getC2CHistoryMessageList(
          userID: userID,
          count: 20,
        );
    messageList = rest.data;
    notifyListeners();
  }

  /// 消息列表插入最新消息
  insertNewMessage(V2TimMessage v2TimMessage) {
    messageList.insert(0,v2TimMessage);
  }
}
