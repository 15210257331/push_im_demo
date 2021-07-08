import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/config.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/login.dart';
import 'package:push_im_demo/provider/app_provider.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/utils/storage.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerPage> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
        color: Color(0xFFf4f4f4),
          child: Column(
            children: [
              buildHeader(),
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
                    children: [
                      // buildSection(),
                      buildContent(),
                      buildSetting(),
                      buildLogout(),
                    ],
                  )
              )
            ],
          )
      )
    );
  }

  Widget buildHeader() {
    return Consumer<ContactProvider>(builder: (context, userInfoProvider, _) {
          return DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              // image: DecorationImage(
              //   image: AssetImage("assets/images/drawer_bg.jpeg"),
              //   fit: BoxFit.fill
              // )
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top:0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(Global?.userInfo?.avatar),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(Global?.userInfo?.englishName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('userId:${Global?.userInfo?.id}',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              ),
            )
          );
        }
    );
  }

  Widget buildSection() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      child: Wrap(
        spacing: 20.0, // 主轴(水平)方向间距
        runSpacing: 15.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.spaceBetween, //沿主轴方向居中
        children: <Widget>[
          Column(
            children: [
              Icon(Icons.message, color: Colors.red,),
              Text('下载')
            ],
          ),
          Column(
            children: [
              Icon(Icons.star, color: Colors.red,),
              Text('我的好友')
            ],
          ),
          Column(
            children: [
              Icon(Icons.message, color: Colors.red,),
              Text('最近播放')
            ],
          ),
          Column(
            children: [
              Icon(Icons.message, color: Colors.red,),
              Text('收藏')
            ],
          ),
          Column(
            children: [
              Icon(Icons.message, color: Colors.red,),
              Text('收藏')
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('消息中心'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('消息中心'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget buildSetting() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text('设置'),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('账号设置'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('夜间模式'),
            trailing: Switch(value: false, onChanged: (_) => {}),
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              return ExpansionTile(
                leading: Icon(Icons.color_lens),
                title: Text('主题设置'),
                initiallyExpanded: false,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: appProvider.themeColorMap.keys.map((key) {
                        Color colorItem = appProvider.themeColorMap[key]['primaryColor'];
                        return InkWell(
                          onTap: () async {
                            Provider.of<AppProvider>(context, listen: false).setTheme(key);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            color: colorItem,
                            child: appProvider.themeColorKey == key ? Icon(Icons.done, color: Colors.white) : null,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  Widget buildLogout() {
    return Container(
      child: FlatButton(
        color: Colors.white,
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        child: Text(
          'log out',
          style: TextStyle(color: Colors.deepOrangeAccent),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
        onPressed: () async{
          await logout();
          // Navigator.of(context).pop();
        },
      ),
    );
  }

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
}
