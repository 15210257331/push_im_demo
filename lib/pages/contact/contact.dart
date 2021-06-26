import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/pages/contact/contact_detail.dart';
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

  List<V2TimFriendInfo> friendList = [];

  @override
  void initState() {
    super.initState();
    getFriendList();
  }

  /// 获取好友列表
  getFriendList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res = await TencentImSDKPlugin
        .v2TIMManager
        .getFriendshipManager()
        .getFriendList();
    if(res.code == 0) {
      setState(() {
        friendList = res.data??[];
      });
    }
  }

  /// 添加好友
  addFriend() async {
    V2TimValueCallback<V2TimFriendOperationResult> res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriend(
              userID: _emailController.value.text,
              addType: FriendType.V2TIM_FRIEND_TYPE_BOTH,
            );
    setState(() {
      print(res);
      if(res.code == 0) {
        getFriendList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系人',
            style: TextStyle(
                color: Colors.white
            )
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: _buildSearch(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child:  Icon(Icons.add,
              size: 28,
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      drawer: DrawerPage(),
      body: Container(
        color: Color(0xFFf4f4f4),
        width: double.infinity,
        child: _buildContacts(),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
        height: 50,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child:  TextField(
              controller: _emailController,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                prefixIcon: Icon(Icons.search, color: Colors.red),
                fillColor: Color(0xffF4F4F4),
                hintText: '输入用户ID',
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
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: addFriend,
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 35,
            ),
          )
        ]
      )
    );
  }

  Widget _buildContacts() {
    return Consumer<ContactProvider>(builder: (context, contactProvider, _) {
      return Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            itemCount: friendList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ContactDetail(userIDList:[friendList[index].userID])
                  ));
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(friendList[index].userProfile.faceUrl),
                  ),
                  title: Text(friendList[index].userProfile.nickName,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  subtitle: Text(friendList[index].userProfile.userID),
                ),
              );
            },
          ),
          Align(
            alignment: new FractionalOffset(1.0, 0.5),
            child: SizedBox(
              width: 25,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: contactProvider.letters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Text(
                        contactProvider.letters[index],
                        style: TextStyle(color: Colors.grey, fontSize: 15),
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
          )
        ],
      );
    });
  }
}
