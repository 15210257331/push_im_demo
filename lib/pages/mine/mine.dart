import 'package:flutter/material.dart';
import 'package:push_im_demo/utils/config.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/login.dart';
import 'package:push_im_demo/utils/storage.dart';

class Mine extends StatefulWidget {
  const Mine({Key key}) : super(key: key);

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {

  /// 退出登录的操作
  Future<void> logout() async {
    await StorageUtil().remove(STORAGE_USER_PROFILE_KEY);
    Global.userInfo = null;
    Global.navigatorKey.currentState.popUntil((Route<dynamic> route) {
      if (route.settings.name == '/') {
        return true;
      } else {
        return false;
      }
    });
    Global.navigatorKey.currentState.pushReplacement(
      MaterialPageRoute(
          builder: (context) => Login(),
          settings: RouteSettings(name: "/")
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
