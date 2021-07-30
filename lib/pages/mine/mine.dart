import 'package:flutter/material.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/drawer/drawer.dart';
import 'package:push_im_demo/pages/mine/setting.dart';
import 'package:push_im_demo/widgets/loading.dart';

class Mine extends StatefulWidget {
  const Mine({Key key}) : super(key: key);

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {

  goSetting() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Setting()
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的',
            style: TextStyle(
                color: Colors.white
            )
        ),
        /// 不指定背景颜色 则使用MaterialApp themData 中定义的颜色
        // backgroundColor: Colors.blueAccent,
        // brightness: Brightness.light,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: DrawerPage(),
      body: Container(
        color: Color(0xFFf4f4f4),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            child: Column(
              children: [
                buildInfo(),
                buildSection(),
                buildSectionItem(title: '支付', icon:Icons.payment),
                buildSectionItem(title: '收藏', icon:Icons.collections_bookmark_rounded),
                buildSectionItem(title: '表情', icon:Icons.emoji_emotions),
                buildSectionItem(title: '设置', icon:Icons.settings, onTap: goSetting),
              ],
            ),
          ),
        )
    );
  }

  Widget buildInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 25,bottom: 25),
      alignment: Alignment.center,
      child: ListTile(
        leading: CircleAvatar(
          radius: 32,
          backgroundImage: Global.userInfo.avatar == null || Global.userInfo.avatar == '' ? AssetImage('assets/images/avatar.png') : NetworkImage(Global.userInfo.avatar),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Global.userInfo.name ?? '',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600
              ),
            ),
            Text('邮箱：${Global.userInfo.email ?? ''}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13
              ),
            ),
          ],
        ),
        trailing: Container(
          child: Icon(Icons.qr_code),
        ),
      ),
    );
  }

  Widget buildSection() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.book, color: Theme.of(context).primaryColor,),
              Text('余额')
            ],
          ),
          Column(
            children: [
              Icon(Icons.directions_subway, color: Theme.of(context).primaryColor,),
              Text('优惠券')
            ],
          ),
          Column(
            children: [
              Icon(Icons.card_travel, color: Theme.of(context).primaryColor,),
              Text('权益卡')
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSectionItem({String title, IconData icon, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

}
