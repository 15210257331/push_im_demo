import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置',
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
      body: Container(
          color: Color(0xFFf4f4f4),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              buildDelete()
            ],
          )
      ),
    );
  }

  Widget buildDelete() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: Colors.red,
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        child: Text(
          '退出登录',
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
        onPressed: () async {

        },
      ),
    );
  }
}
