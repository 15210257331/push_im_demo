import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/contact/contact.dart';
import 'package:push_im_demo/pages/conversation/conversation.dart';
import 'package:push_im_demo/pages/news/news.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/utils/createUserSign.dart';
import 'package:push_im_demo/utils/update.dart';
import 'package:tencent_im_sdk_plugin/enum/log_level.dart';
import 'package:tencent_im_sdk_plugin/manager/v2_tim_manager.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
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
        listener: (data) {
          print(data);
        },
      );
      //关系链监听
      timManager.getFriendshipManager().setFriendListener(
        listener: (data) {
          print(data);
        },
      );
      //会话监听
      timManager.getConversationManager().setConversationListener(
        listener: (data) {
          print(data);
        },
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
      }else{
        print(loginRes.desc);
      }
    }else{
      print('init fail');
    }
  }

  /// 设置用户资料
  setSelfInfo() async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
      nickName: Global.userInfo.englishName,
      faceUrl: Global.userInfo.avatar,
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
