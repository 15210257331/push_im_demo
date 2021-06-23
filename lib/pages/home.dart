import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/message/message.dart';
import 'package:push_im_demo/pages/news/news.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/utils/createUserSign.dart';
import 'package:tencent_im_sdk_plugin/enum/log_level.dart';
import 'package:tencent_im_sdk_plugin/manager/v2_tim_manager.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  int _tabIndex = 0;

  /// 获取联系人数据
  Future<void> getContactList() async {
    // await Provider.of<ContactProvider>(context, listen: false).getContactList();
  }

  initIM() async {
    //获取腾讯即时通信IM manager;
    V2TIMManager timManager = TencentImSDKPlugin.v2TIMManager;
    //初始化SDK
    V2TimValueCallback<bool> initRes = await timManager.initSDK(
      sdkAppID: 1400534652,
      loglevel: LogLevel.V2TIM_LOG_DEBUG,
      listener: (data) {
        print(data);
      },
    );

    //V2TimValueCallback 返回的所有数据结构
    //int code initRes.code；
    //String desc = initRes.desc;
    //bool data = initRes.data;//为V2TimValueCallback实例化时接收的泛型。

    if(initRes.code == 0){
      //初始化成功
      //以下监听可按需设置,为防止遗漏消息，请在登录前设置监听。
      //高级消息监听
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
        V2TimValueCallback<V2TimConversationResult> res = await timManager.getConversationManager().getConversationList(nextSeq: 0, count: 100);
        print(res);
        //发送消息
        timManager.sendC2CTextMessage(text:'你好',userID: '2438',);
        //....
        //这里可调用SDK的任何方法。
      }else{
        //登录失败
        print(loginRes.desc);
      }
    }else{
      //初始化失败
      print('init fail');
    }
  }


  @override
  void initState() {
    super.initState();
    getContactList();
    initIM();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          News(),
          Message(),
          Message()
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 26,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        backgroundColor: Colors.white,
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: '新闻',
              icon: Icon(Icons.home, color: Colors.grey),
              activeIcon: Icon(Icons.home, color: Colors.red)
          ),
          BottomNavigationBarItem(
              label: '聊天',
              icon: Icon(Icons.notification_important, color: Colors.grey),
              activeIcon: Icon(Icons.notification_important, color: Colors.red)
          ),
          BottomNavigationBarItem(
              label: '推送',
              icon: Icon(Icons.sentiment_very_satisfied, color: Colors.grey),
              activeIcon: Icon(Icons.sentiment_very_satisfied, color: Colors.red)
          ),
        ],
      ),
    );
  }
}
