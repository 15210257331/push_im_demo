import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/contact/contact.dart';
import 'package:push_im_demo/pages/conversation/conversation.dart';
import 'package:push_im_demo/pages/news/news.dart';
import 'package:push_im_demo/provider/conversation_provider.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/utils/createUserSign.dart';
import 'package:push_im_demo/utils/update.dart';
import 'package:tencent_im_sdk_plugin/enum/log_level.dart';
import 'package:tencent_im_sdk_plugin/manager/v2_tim_manager.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_progress.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message_receipt.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    initIM();
    if (Global.isRelease == true) {
      doAppUpdate();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  initIM() async {
    V2TIMManager timManager = TencentImSDKPlugin.v2TIMManager;
    V2TimValueCallback<bool> initRes = await timManager.initSDK(
      sdkAppID: 1400534652,
      loglevel: LogLevel.V2TIM_LOG_DEBUG,
      listener: (data) {
        print(data);
      },
    );
    if(initRes.code == 0){
      /// 以下监听可按需设置,为防止遗漏消息，请在登录前设置监听。高级消息监听
      timManager.getMessageManager().addAdvancedMsgListener(
        listener: advancedMsgListener,
      );
      /// 简单消息监听
      timManager.addSimpleMsgListener(
        listener: simpleMsgListener,
      );
      /// 关系链监听
      timManager.getFriendshipManager().setFriendListener(
        listener: friendListener,
      );
      /// 会话监听
      timManager.getConversationManager().setConversationListener(
        listener: conversationListener,
      );
      //设置信令相关监听
      timManager.getSignalingManager().addSignalingListener(
        listener: (data) {
          print(data);
        },
      );
      String userSig = new GenerateTestUserSig(
        sdkappid: 1400534652,
        key: '0bd159339d9c18e0addae23050149b23fe050b9df964ed559142f7b307e5f8f0',
      ).genSig(
        identifier: Global.userInfo.id.toString(),
        expire: 7 * 24 * 60 * 1000, // userSIg有效期
      );
      /// 登录
      V2TimCallback loginRes = await timManager.login(
        userID: Global.userInfo.id.toString(),
        userSig: userSig,
      );
      /// 登录成功
      if(loginRes.code==0){
        setSelfInfo();
        // 加载好友列表
        Provider.of<ContactProvider>(context, listen: false).loadFriendList();
      }else{
        print(loginRes.desc);
      }
    }else{
      print('init fail');
    }
  }

  /// 简单消息监听
  simpleMsgListener(data) {
    print(data);
  }

  /// 高级消息监听
  advancedMsgListener(data) {
    print("advancedMsgListener emit");
    print(data.type);
    /// 收到消息回调
    if (data.type == 'onRecvNewMessage') {
      try {
        List<V2TimMessage> messageList = [];
        V2TimMessage message = data.data;
        messageList.add(data.data);
        print("c2c_${message.sender}");
        String key;
        if (message.groupID == null) {
          key = message.sender;
        } else {
          key = message.groupID;
        }
        Provider.of<ConversationProvider>(context, listen: false).addMessages(key, messageList);
      } catch (err) {
        print(err);
      }
    }
    /// 对方收到消息已读的回调
    if (data.type == 'onRecvC2CReadReceipt') {
      print('收到了新消息 已读回执');
      List<V2TimMessageReceipt> list = data.data;
      list.forEach((element) {
        print("已读回执${element.userID} ${element.timestamp}");
        Provider.of<ConversationProvider>(context, listen: false).updateCurrentMessageList(element.userID);
      });
    }
    /// 消息撤回回调
    if (data.type == 'onRecvMessageRevoked') {
      //消息撤回 TODO
    }
    /// 发送消息进度回调
    if (data.type == 'onSendMessageProgress') {
      MessageProgress msgPro = data.data;
      V2TimMessage message = msgPro.message;
      String key;
      if (message.groupID == null) {
        key = message.userID;
      } else {
        key = message.groupID;
      }
      try {
        Provider.of<ConversationProvider>(context, listen: false,).addOneMessageIfNotExits(key, message);
      } catch (err) {
        print("error $err");
      }
      print("消息发送进度 ${msgPro.progress} 消息状态${message.status}");
    }
  }

  /// 会话监听
  conversationListener(data) {
    String type = data.type;
    if(type == 'onSyncServerFinish') {
      Provider.of<ConversationProvider>(context, listen: false).loadConversationList();
    }
    if (type == 'onNewConversation' || type == 'onConversationChanged') {
      try {
        List<V2TimConversation> list = data.data;
        Provider.of<ConversationProvider>(context, listen: false).setConversionList(list);
        //如果当前会话在使用中，也更新一下

      } catch (e) {}
    } else {
      print("$type emit but no nerver use");
    }
  }

  /// 好友关系监听
  friendListener(data) async {
    print("friendListener emit");
    String type = data.type;
    if (type == 'onFriendListAdded' || type == 'onFriendListDeleted' || type == 'onFriendInfoChanged' || type == 'onBlackListDeleted') {
      //好友加成功了，删除好友 重新获取好友
      Provider.of<ContactProvider>(context, listen: false).loadFriendList();
    }
    if (type == 'onFriendApplicationListAdded') {
      // 收到加好友申请,添加双向好友时双方都会周到这个回调，这时要过滤掉type=2的不显示
      // List<V2TimFriendApplication> list = data.data;
      // print("收到加好友申请");
      // List<V2TimFriendApplication> newlist = new List<V2TimFriendApplication>();
      // list.forEach((element) {
      //   if (element.type != 2) {
      //     newlist.add(element);
      //   }
      // });
      // if (newlist.isNotEmpty) {
      //   Provider.of<FriendApplicationModel>(context, listen: false)
      //       .setFriendApplicationResult(newlist);
      // }
    }
    print(data.type);
  }

  /// 设置用户资料
  setSelfInfo() async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
      nickName: Global.userInfo.englishName,
      faceUrl: Global.userInfo.avatar,
      selfSignature: '这是我的个性签名'
    );
  }

  /// 版本升级
  Future doAppUpdate() async {
    await Future.delayed(Duration(seconds: 3), () async {
      if (Global.isIOS == false &&
          await Permission.storage.isGranted == false) {
        await [Permission.storage].request();
      }
      if (await Permission.storage.isGranted) {
        AppUpdateUtil().run(context);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          Conversation(),
          Contact(),
          News(),
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 26,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: '聊天',
              icon: Icon(Icons.notifications, color: Colors.grey),
              activeIcon: Icon(Icons.notifications, color: Theme.of(context).primaryColor)
          ),
          BottomNavigationBarItem(
              label: '联系人',
              icon: Icon(Icons.supervisor_account_sharp, color: Colors.grey),
              activeIcon: Icon(Icons.supervisor_account_sharp, color: Theme.of(context).primaryColor)
          ),
          BottomNavigationBarItem(
              label: '新闻',
              icon: Icon(Icons.sentiment_very_satisfied, color: Colors.grey),
              activeIcon: Icon(Icons.sentiment_very_satisfied, color: Theme.of(context).primaryColor)
          ),
        ],
      ),
    );
  }
}
