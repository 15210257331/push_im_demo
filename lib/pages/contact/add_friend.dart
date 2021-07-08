import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:tencent_im_sdk_plugin/enum/friend_type.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key key}) : super(key: key);

  @override
  _ContactAddState createState() => _ContactAddState();
}

class _ContactAddState extends State<AddFriend> {

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _emailController = TextEditingController();

  /// 添加好友
  addFriend() async {
    if(_emailController.value.text == '' || _emailController.value.text == null) {
      return;
    }
    V2TimValueCallback<V2TimFriendOperationResult> res =
    await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriend(
      userID: _emailController.value.text,
      addType: FriendType.V2TIM_FRIEND_TYPE_BOTH,
    );
    if (res.code == 0) {
      EasyLoading.showSuccess('添加成功', duration: Duration(seconds: 1));
      Provider.of<ContactProvider>(context, listen: false).loadFriendList();
      Global.navigatorKey.currentState.pop();
    } else {
      EasyLoading.showError('添加失败${res.desc}', duration: Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加联系人', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            buildSearch(),
            buildButton()
          ],
        ),
      ),
    );
  }

  Widget buildSearch() {
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
            suffixIcon:
            GestureDetector(
              onTap: () {
                _emailController.clear();
              },
              child: Icon(Icons.close, color: Theme.of(context).primaryColor),
            ),
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
        )
    );
  }

  Widget buildButton() {
    return CupertinoButton(
        child: Text(          //按钮label
        '添加好友',
        ),
        color: Theme.of(context).primaryColor, //按钮颜色
        onPressed: addFriend,
    );
  }
}
