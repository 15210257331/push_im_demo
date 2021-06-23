import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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

  int page = 1;

  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    getNewsList(type: widget.type, page: 10, pageSize: 10);
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
  }


  getNewsList({String type, int page, int pageSize}) async{
    Map<String, dynamic> params = {
      'key': '1f301d9c025202c4231a2f13c27817fe',
      'type': type,
      'page': page,
      'page_size': pageSize
    };
    newsList = await NewsAPI.getNewsList(context: context, params: params);
    setState(() {

    });
  }

  pushNewsList({String type, int page, int pageSize}) async{
    Map<String, dynamic> params = {
      'key': '1f301d9c025202c4231a2f13c27817fe',
      'type': type,
      'page': page,
      'page_size': pageSize
    };
    List arr = await NewsAPI.getNewsList(context: context, params: params);
    newsList.addAll(arr);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
   return EasyRefresh(
      enableControlFinishRefresh: false,
      enableControlFinishLoad: false,
      controller: _easyRefreshController,
      onRefresh: () async {
        page = 1;
        await getNewsList(page: page, pageSize: pageSize);
        _easyRefreshController.resetLoadState();
      },
      onLoad: () async {
        page += 1;
        if (newsList.length < newsTotal) {
          await pushNewsList(page: page, pageSize: pageSize);
        }
        _easyRefreshController.finishLoad(
            noMore: newsList.length >= newsTotal
        );
      },
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return buildNewsItem(newsList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
              color: Colors.grey,
              height: 0.5,
              // indent: 15
          );
        },
        padding: EdgeInsets.only(left: 10, right: 10),
        itemCount: newsList.length,
      ),
    );
  }

  Widget buildNewsItem(dynamic item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => NewsDetail(id:item['uniquekey']))
        );
      },
      child:  Container(
        height: 80,
        margin: EdgeInsets.only(top: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.network(item['thumbnail_pic_s'],
                width: 80,
                scale: 2.5,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                          fontFamily: 'PingFangSC-Regular, PingFang SC',
                          fontWeight: FontWeight.w600,
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['author_name']),
                        Text(item['date'])
                      ],
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
