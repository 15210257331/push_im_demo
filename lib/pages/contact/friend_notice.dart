import 'package:flutter/material.dart';
import 'package:push_im_demo/widgets/empty.dart';

class FriendNotice extends StatefulWidget {
  const FriendNotice({Key key}) : super(key: key);

  @override
  _FriendNoticeState createState() => _FriendNoticeState();
}

class _FriendNoticeState extends State<FriendNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('好友通知', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: buildNoticeList(),
      ),
    );
  }

  Widget buildNoticeList() {
    return Empty();
  }
}
