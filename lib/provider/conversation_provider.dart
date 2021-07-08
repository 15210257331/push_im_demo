import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';


class ConversationProvider with ChangeNotifier {

  /// 保存当前登录用户的所有聊天 已map形式保存
  /// key  为用户ID
  /// value 为聊天列表
  Map<String, List<V2TimMessage>> _allMessageMap = new Map();

  get allMessageMap => _allMessageMap;

  /// 当前登录用户的会话列表
  List<V2TimConversation> _conversionList = [];

  get conversionList => _conversionList;


  /// 将当前会话的聊天列表标记为已读
  updateCurrentMessageList(String key) {
    if (_allMessageMap.containsKey(key)) {
      List<V2TimMessage> currentMessageList = _allMessageMap[key];
      currentMessageList.forEach((element) {
        element.isPeerRead = true;
      });
      _allMessageMap[key] = currentMessageList;
      notifyListeners();
    } else {
      print("会话列表不存在这个userid key");
    }
  }

  /// 向当前会话的聊天列表中添加多条信息
  addMessages(String key, List<V2TimMessage> v2TimMessage) {
    if (_allMessageMap.containsKey(key)) {
      _allMessageMap[key].addAll(v2TimMessage);
    } else {
      List<V2TimMessage> messageList = [];
      messageList.addAll(v2TimMessage);
      _allMessageMap[key] = messageList;
    }
    // 消息去重
    Map<String, V2TimMessage> rebuildMap = new Map<String, V2TimMessage>();
    _allMessageMap[key].forEach((element) {
      rebuildMap[element.msgID] = element;
    });
    _allMessageMap[key] = rebuildMap.values.toList();
    rebuildMap.clear();
    // 排序
    // _allMessageMap[key].sort((left, right) => left.timestamp.compareTo(right.timestamp));
    notifyListeners();
  }

  /// 向当前会话的聊天列表中添加一条信息
  addOneMessageIfNotExits(String key, V2TimMessage message) {
    if (_allMessageMap.containsKey(key)) {
      bool hasMessage = _allMessageMap[key].any((element) => element.msgID == message.msgID);
      if (hasMessage) {
        int idx = _allMessageMap[key]
            .indexWhere((element) => element.msgID == message.msgID);
        _allMessageMap[key][idx] = message;
      } else {
        _allMessageMap[key].insert(0,message);
      }
    } else {
      List<V2TimMessage> messageList = [];
      messageList.add(message);
      _allMessageMap[key] = messageList;
    }
    // _allMessageMap[key].sort((left, right) => left.timestamp.compareTo(right.timestamp));
    notifyListeners();
    return _allMessageMap;
  }

  deleteMessage(String key) {
    _allMessageMap.remove(key);
    notifyListeners();
  }

  clearMessageMap() {
    _allMessageMap = new Map();
    notifyListeners();
  }

  loadConversationList() async {
    V2TimValueCallback<V2TimConversationResult> res = await TencentImSDKPlugin
        .v2TIMManager
        .getConversationManager()
        .getConversationList(nextSeq: 0, count: 50);
    if(res.code == 0) {
      _conversionList = res.data.conversationList;
      notifyListeners();
      return _conversionList;
    }
  }

  setConversionList(List<V2TimConversation> newList) {
    newList.forEach((element) {
      String cid = element.conversationID;
      if (_conversionList.any((ele) => ele.conversationID == cid)) {
        for (int i = 0; i < _conversionList.length; i++) {
          if (_conversionList[i].conversationID == cid) {
            conversionList[i] = element;
            break;
          }
        }
      } else {
        _conversionList.add(element);
      }
    });
    _conversionList.sort((left, right) =>
        right.lastMessage.timestamp.compareTo(left.lastMessage.timestamp));
    notifyListeners();
    return _conversionList;
  }

  removeConversionByConversationId(String conversionId) {
    _conversionList
        .removeWhere((element) => element.conversationID == conversionId);
    notifyListeners();
  }

  /// 清空会话
  clearConversation() {
    _conversionList = [];
    notifyListeners();
    return _conversionList;
  }
}