import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/contact/black_list.dart';
import 'package:push_im_demo/pages/contact/add_friend.dart';
import 'package:push_im_demo/pages/contact/friend_info.dart';
import 'package:push_im_demo/pages/conversation/conversation_detail.dart';
import 'package:push_im_demo/pages/drawer/drawer.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:tencent_im_sdk_plugin/enum/friend_type.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final TextEditingController _emailController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;

  /// 索引名称列表
  List<String> indexNames = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  void initState() {
    super.initState();
  }

  goFriendNotice() {

  }

  goGroup() {

  }

  goBlackList() {
    Global.navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => BlackList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系人', style: TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: _buildSearch(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                Global.navigatorKey.currentState.push(
                  MaterialPageRoute(
                      builder: (context) => AddFriend(),
                  ),
                );
              },
              child: Icon(
                Icons.add_circle,
                size: 35,
              ),
            )
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      drawer: DrawerPage(),
      body: Container(
          color: Color(0xFFf4f4f4),
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  buildFixItem(title: '好友通知', onTap: goFriendNotice),
                  buildFixItem(title: '我的群聊', onTap: goGroup),
                  buildFixItem(title: '黑名单', border: false,onTap: goBlackList),
                  Expanded(
                    child: buildFriendList(),
                  )
               ]
              ),
              buildIndexName()
            ],
          )),
    );
  }

  Widget _buildSearch() {
    return Container(
        height: 50,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextField(
          controller: _emailController,
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            fillColor: Color(0xffF4F4F4),
            hintText: '搜索好友',
            filled: true,
            enabledBorder: OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(15), //边角为5
              ),
              borderSide: BorderSide(
                color: Colors.white, //边线颜色为白色
                width: 1, //边线宽度为2
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white, //边框颜色为白色
                width: 1, //宽度为5
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15), //边角为30
              ),
            ),
          ),
        )
    );
  }

  Widget buildFixItem({String title, bool border= true, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          title: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
                border: Border(
              bottom: border == true
                  ? BorderSide(
                      width: 1,
                      color: Color(0xFFEBEBEB),
                    )
                  : BorderSide.none,
            )),
            child: Text(title),
          ),
        ),
      ),
    );
  }

  Widget buildFriendList() {
    return Consumer<ContactProvider>(builder: (context, contactProvider, _) {
      List<V2TimFriendInfo> friendList = contactProvider.contactList;
      return ListView.separated(
        itemCount: friendList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendInfo(
                          userID: friendList[index]?.userID)
                  )
              );
            },
            child: buildContactItem(friendList[index],
                showIndexName: index < 2 ? true : false),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Color(0xFFEBEBEB),
            indent: 170,
            height: 1,
          );
        },
      );
    });
  }

  Widget buildContactItem(V2TimFriendInfo v2TimFriendInfo, {bool showIndexName}) {
    String indexName = '';
    if(showIndexName == true) {
       indexName = v2TimFriendInfo.userProfile.nickName != '' && v2TimFriendInfo.userProfile.nickName != null ? v2TimFriendInfo.userProfile.nickName.substring(0,1) : 'A';
    }
    return Column(
      children: [
        showIndexName == true
            ? Container(
                padding: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
                width: double.infinity,
                color: Color(0xFFf4f4f4),
                child: Text(indexName),
              )
            : Container(),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          color: Colors.white,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: v2TimFriendInfo.userProfile.faceUrl == null ||
                  v2TimFriendInfo.userProfile.faceUrl == ''
                  ? AssetImage('assets/images/avatar.png')
                  : NetworkImage(v2TimFriendInfo.userProfile.faceUrl),
            ),
            title: Text(
              v2TimFriendInfo.userProfile.nickName == '' ? v2TimFriendInfo.userProfile.userID : v2TimFriendInfo.userProfile.nickName,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(v2TimFriendInfo.userProfile.userID),
          ),
        )
      ],
    );
  }

  /// 构建索引名称列表
  Widget buildIndexName() {
    return Align(
      alignment: new FractionalOffset(1.0, 0.5),
      child: SizedBox(
        width: 25,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: indexNames.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Text(
                  indexNames[index],
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                  var height = index * 45.0;
                  for (int i = 0; i < index; i++) {
                    // height += data[i].listData.length * 46.0;
                  }
                  _scrollController.jumpTo(height);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
