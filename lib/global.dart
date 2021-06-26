import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:push_im_demo/config.dart';
import 'package:push_im_demo/model/user_info.dart';
import 'package:push_im_demo/utils/http.dart';
import 'package:push_im_demo/utils/storage.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

/// 全局配置
class Global {

  /// 顶层路由导航的key 用于获取Navigator对象
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  /// 全局 context
  static GlobalKey globalContextKey = new GlobalKey();

  /// 路由跳转监听对象
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  /// 已登录用户信息
  static UserInfo userInfo;

  /// 发布渠道
  static String channel = "xiaomi";

  /// 是否 ios
  static bool isIOS = Platform.isIOS;

  /// android 设备信息
  static AndroidDeviceInfo androidDeviceInfo;

  /// ios 设备信息
  static IosDeviceInfo iosDeviceInfo;

  /// 包信息
  static PackageInfo packageInfo;

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 读取设备信息
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Global.isIOS) {
      Global.iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    } else {
      Global.androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    }

    // 包信息
    Global.packageInfo = await PackageInfo.fromPlatform();

    // 本地存储
    await StorageUtil.init();

    // http 初始
    HttpUtil();

    // 读取设备第一次打开
    isFirstOpen = !StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      StorageUtil().setBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // 读取用户信息，判断是否登陆
    var data = StorageUtil().getJSON(STORAGE_USER_PROFILE_KEY);
    if (data != null) {
      userInfo = UserInfo.fromJson(data);
    }

    /// 开启DEBUG
    XgFlutterPlugin().setEnableDebug(true);

    /// 如果您的应用非广州集群则需要在startXG之前调用此函数
    /// 香港：tpns.hk.tencent.com
    /// 新加坡：tpns.sgp.tencent.com
    /// 上海：tpns.sh.tencent.com
    /// XgFlutterPlugin().configureClusterDomainName("tpns.hk.tencent.com");

    /// 启动TPNS服务
    if(Platform.isAndroid) {
      XgFlutterPlugin().startXg("1500018481", "AW8Y2K3KXZ38");
    } else if(Platform.isIOS) {
      XgFlutterPlugin().startXg("1600020233", "IMBWYTRSFGZ6");
      /// 同步角标值到TPNS服务器 仅仅iOS生效
      XgFlutterPlugin().setBadge(0);
    }

    // 注册回调
    XgFlutterPlugin().addEventHandler(
      onRegisteredDeviceToken: (String token) async {
        print("flutter onRegisteredDeviceToken: $token");
      },
      /// 注册完成获取token回调,上传token至后台
      onRegisteredDone: (String token) async {
        // await uploadDeviceToken(token);
      },
      /// 注销完成的回调
      unRegistered: (String msg) async {
        print("flutter unRegistered: $msg");
        // showToast("注销完成的回调$msg", duration: Duration(seconds: 60));
      },
      /// 收到通知消息回调type = 3 标识通知消息
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        print("flutter onReceiveNotificationResponse $msg");
        // showToast("$msg", duration: Duration(seconds: 60));
      },
      /// Android透传消息、iOS静默消息 回调接口
      onReceiveMessage: (Map<String, dynamic> msg) async {
        print("接受透传消息或静默消息 $msg");
      },
      /// 同步角标值到TPNS服务器成功回调 仅仅iOS生效
      xgPushDidSetBadge: (String msg) async {
        print("flutter xgPushDidSetBadge: $msg");
        /// 在此可设置应用角标
        XgFlutterPlugin().setAppBadge(0);
      },
      /// 通知点击时的回调
      xgPushClickAction: (Map<String, dynamic> msg) async {
        // showToast("点击推送消息",duration: Duration(seconds: 10));
      },
    );
  }

  // 持久化用户信息
  static Future<bool> saveProfile(UserInfo userResponse) {
    userInfo = userResponse;
    return StorageUtil().setJSON(STORAGE_USER_PROFILE_KEY, userResponse.toJson());
  }
}
