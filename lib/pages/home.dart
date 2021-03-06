import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/contact/contact.dart';
import 'package:push_im_demo/pages/conversation/conversation.dart';
import 'package:push_im_demo/pages/mine/mine.dart';
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
      /// ???????????????????????????,????????????????????????????????????????????????????????????????????????
      timManager.getMessageManager().addAdvancedMsgListener(
        listener: advancedMsgListener,
      );
      /// ??????????????????
      timManager.addSimpleMsgListener(
        listener: simpleMsgListener,
      );
      /// ???????????????
      timManager.getFriendshipManager().setFriendListener(
        listener: friendListener,
      );
      /// ????????????
      timManager.getConversationManager().setConversationListener(
        listener: conversationListener,
      );
      //????????????????????????
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
        expire: 7 * 24 * 60 * 1000, // userSIg?????????
      );
      /// ??????
      V2TimCallback loginRes = await timManager.login(
        userID: Global.userInfo.id.toString(),
        userSig: userSig,
      );
      /// ????????????
      if(loginRes.code==0){
        setSelfInfo();
        loadFriendList();
      }else{
        print(loginRes.desc);
      }
    }else{
      print('init fail');
    }
  }

  /// ??????????????????
  simpleMsgListener(data) {
    print(data);
  }

  /// ??????????????????
  advancedMsgListener(data) {
    print("advancedMsgListener emit");
    print(data.type);
    /// ??????????????????
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
    /// ?????????????????????????????????
    if (data.type == 'onRecvC2CReadReceipt') {
      print('?????????????????? ????????????');
      List<V2TimMessageReceipt> list = data.data;
      list.forEach((element) {
        print("????????????${element.userID} ${element.timestamp}");
        Provider.of<ConversationProvider>(context, listen: false).updateCurrentMessageList(element.userID);
      });
    }
    /// ??????????????????
    if (data.type == 'onRecvMessageRevoked') {
      //???????????? TODO
    }
    /// ????????????????????????
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
      print("?????????????????? ${msgPro.progress} ????????????${message.status}");
    }
  }

  /// ????????????
  conversationListener(data) {
    String type = data.type;
    if(type == 'onSyncServerFinish') {
      Provider.of<ConversationProvider>(context, listen: false).loadConversationList();
    }
    if (type == 'onNewConversation' || type == 'onConversationChanged') {
      try {
        List<V2TimConversation> list = data.data;
        Provider.of<ConversationProvider>(context, listen: false).setConversionList(list);
        //????????????????????????????????????????????????

      } catch (e) {}
    } else {
      print("$type emit but no nerver use");
    }
  }

  /// ??????????????????
  friendListener(data) async {
    print("friendListener emit");
    String type = data.type;
    if (type == 'onFriendListAdded' || type == 'onFriendListDeleted' || type == 'onFriendInfoChanged' || type == 'onBlackListDeleted') {
      //????????????????????????????????? ??????????????????
      // Provider.of<ContactProvider>(context, listen: false).loadFriendList();
    }
    if (type == 'onFriendApplicationListAdded') {
      // ?????????????????????,????????????????????????????????????????????????????????????????????????type=2????????????
      // List<V2TimFriendApplication> list = data.data;
      // print("?????????????????????");
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

  /// ??????????????????
  setSelfInfo() async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
      nickName: Global.userInfo.englishName,
      faceUrl: Global.userInfo.avatar,
      selfSignature: '????????????????????????'
    );
  }

  /// ??????????????????
  loadFriendList() async {
    Provider.of<ContactProvider>(context, listen: false).loadFriendList();
  }

  /// ????????????
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
          Mine(),
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
              label: '??????',
              icon: Icon(Icons.message_outlined, color: Colors.grey),
              activeIcon: Icon(Icons.message_outlined, color: Theme.of(context).primaryColor)
          ),
          BottomNavigationBarItem(
              label: '?????????',
              icon: Icon(Icons.supervisor_account_sharp, color: Colors.grey),
              activeIcon: Icon(Icons.supervisor_account_sharp, color: Theme.of(context).primaryColor)
          ),
          BottomNavigationBarItem(
              label: '??????',
              icon: Icon(Icons.alternate_email_outlined, color: Colors.grey),
              activeIcon: Icon(Icons.alternate_email_outlined, color: Theme.of(context).primaryColor)
          ),
          BottomNavigationBarItem(
              label: '??????',
              icon: Icon(Icons.sentiment_very_satisfied, color: Colors.grey),
              activeIcon: Icon(Icons.sentiment_very_satisfied, color: Theme.of(context).primaryColor)
          ),
        ],
      ),
    );
  }
}
