import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:push_im_demo/api/http.dart';
import 'package:push_im_demo/api/news_api.dart';
import 'package:push_im_demo/pages/news/news_detail.dart';

class NewsList extends StatefulWidget {
  final String type;

  NewsList(this.type);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  EasyRefreshController _easyRefreshController = EasyRefreshController();

  List<dynamic> newsList = [];

  int newsTotal = 1000;

  int offset = 0;

  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    getNewsList(type: widget.type, offset: offset, pageSize: pageSize);
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
  }

  getNewsList({String type, int offset, int pageSize}) async {
    Map<String, dynamic> params = {
      'key': '3581767697229db9cde4851391233f1c',
      'type': type,
      'size': pageSize,
      'offset': offset
    };
    var response = await HttpUtil().get(
      'http://apis.juhe.cn/fapig/douyin/billboard',
      context: context,
      params: params,
    );
    newsList = response['result'];
    setState(() {});
  }

  pushNewsList({String type, int offset, int pageSize}) async {
    Map<String, dynamic> params = {
      'key': '3581767697229db9cde4851391233f1c',
      'type': type,
      'size': pageSize,
      'offset': offset
    };
    var response = await HttpUtil().get(
      'http://apis.juhe.cn/fapig/douyin/billboard',
      context: context,
      params: params,
    );
    List arr = response['result'];
    newsList.addAll(arr);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFFf4f4f4),
      padding: EdgeInsets.only(top: 10),
      child: EasyRefresh(
        enableControlFinishRefresh: false,
        enableControlFinishLoad: false,
        controller: _easyRefreshController,
        onRefresh: () async {
          offset = 0;
          getNewsList(type: widget.type, offset: offset, pageSize: pageSize);
          _easyRefreshController.resetLoadState();
        },
        onLoad: () async {
          offset += pageSize;
          if (newsList.length < newsTotal) {
            pushNewsList(type: widget.type, offset: offset, pageSize: pageSize);
          }
          _easyRefreshController.finishLoad(noMore: newsList.length >= newsTotal);
        },
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return buildNewsItem(newsList[index]);
          },
          padding: EdgeInsets.only(left: 10, right: 10),
          itemCount: newsList.length,
        ),
      ),
    );
  }

  Widget buildNewsItem(dynamic item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              item['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(right: 10),
                child: Image.network(
                  item['item_cover'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageRouteBuilder(pageBuilder:
                        (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: NewsDetail(url: item['share_url']),
                      );
                    }));
                  },
                  child: Icon(
                    Icons.play_circle_outline_sharp,
                    size: 70,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['author'],
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${item['comment_count']} 评论',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
