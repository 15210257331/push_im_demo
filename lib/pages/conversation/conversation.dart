import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:push_im_demo/pages/conversation/conversation_detail.dart';
import 'package:push_im_demo/pages/drawer/drawer.dart';
import 'package:push_im_demo/utils/date_utls.dart';
import 'package:tencent_im_sdk_plugin/enum/message_elem_type.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  EasyRefreshController _easyRefreshController = EasyRefreshController();

  final TextEditingController textEditingController = TextEditingController();

  int nextSeq = 0;

  List<V2TimConversation> conversationList = [];

  @override
  void initState() {
    super.initState();
    getConversationList();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    _easyRefreshController.dispose();
  }

  getConversationList() async {
    V2TimValueCallback<V2TimConversationResult> res = await TencentImSDKPlugin
        .v2TIMManager
        .getConversationManager()
        .getConversationList(nextSeq: nextSeq, count: 50);
    setState(() {
      conversationList = res.data.conversationList;
      print(conversationList);
      // nextSeq = res['data']['nextSeq'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('聊天',
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
          child:EasyRefresh(
            enableControlFinishRefresh: false,
            enableControlFinishLoad: false,
            controller: _easyRefreshController,
            onRefresh: () async {
              await getConversationList();
              _easyRefreshController.resetLoadState();
            },
            onLoad: () async {
              // page += 1;
              // if (conversationList.length < newsTotal) {
              //   await pushNewsList(page: page, pageSize: pageSize);
              // }
              // _easyRefreshController.finishLoad(
              //     noMore: newsList.length >= newsTotal
              // );
            },
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ConversationDetail(conversationID: conversationList[index].conversationID)
                      ));
                    },
                    child: buildConversationItem(conversationList[index]),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => print('Delete'),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Color(0xFFEBEBEB),
                  // indent: 70,
                  height: 1,
                );
              },
              itemCount: conversationList.length,
            ),
          ),
        )
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: TextField(
        controller: textEditingController,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          prefixIcon: Icon(Icons.search, color: Colors.black12),
          fillColor: Color(0xffF4F4F4),
          hintText: '搜索',
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
    );
  }

  Widget buildConversationItem(V2TimConversation conversation) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: Container(
            width: 50,
            height: 50,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(conversation.faceUrl),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(conversation.showName),
              Text(DateUtils.timestampToLocalDateYMD(conversation.lastMessage.timestamp)),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                  child: buildLastMessageDetail(conversation)
              ),
              Badge(
                padding: EdgeInsets.all(6),
                showBadge: conversation.unreadCount > 0 ? true : false,
                toAnimate: true,
                badgeColor: Colors.deepOrangeAccent,
                badgeContent: Text(conversation.unreadCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
      ),
    );
  }

  Widget buildLastMessageDetail(V2TimConversation conversation) {
    switch (conversation.lastMessage.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return Text(conversation.lastMessage.textElem.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return Text('[IMAGE]');
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return Text('[SOUND]');
      default:
        return Container(height: 40, child: Center(child: Text("MsgBodyTypeError")));
    }
  }
}
