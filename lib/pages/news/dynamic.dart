import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:push_im_demo/api/http.dart';

class Dynamic extends StatefulWidget {
  const Dynamic({Key key}) : super(key: key);

  @override
  _DynamicState createState() => _DynamicState();
}

class _DynamicState extends State<Dynamic> {

  EasyRefreshController _easyRefreshController = EasyRefreshController();

  List<dynamic> newsList = [];

  int pageSize = 10;

  int offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList(offset: offset,pageSize: pageSize, isPush: false);
  }

  getNewsList({int offset, int pageSize, bool isPush}) async {
    Map<String, dynamic> params = {
      'key': '1f301d9c025202c4231a2f13c27817fe',
      'type': 'top',
      'size': pageSize,
      'offset': offset
    };
    var response = await HttpUtil().get(
      'http://v.juhe.cn/toutiao/index?type=top&key=APPKEY',
      context: context,
      params: params,
    );
    if(isPush == true) {
      var arr = response['result']['data'];
      newsList.addAll(arr);
    }else {
      newsList = response['result']['data'];
    }
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
          getNewsList(offset: offset,pageSize: pageSize, isPush: false);
          _easyRefreshController.resetLoadState();
        },
        onLoad: () async {
          offset += pageSize;
          if (newsList.length < 1000) {
            getNewsList(offset: offset,pageSize: pageSize, isPush: true);
          }
          _easyRefreshController.finishLoad(noMore: newsList.length >= 1000);
        },
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return buildDynamicItem(newsList[index]);
          },
          padding: EdgeInsets.only(left: 10, right: 10),
          itemCount: newsList.length,
        ),
      ),
    );
  }
  
  Widget buildDynamicItem(dynamic item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://dfzximg02.dftoutiao.com/news/20210308/20210308134708_d0216565f1d6fe1abdfa03efb4f3e23c_0_mwpm_03201609.png'),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['author_name'] ?? '',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 15
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(item['date'] ?? '',
                        style: TextStyle(
                            color: Color(0xFF999999),
                          fontSize: 12
                        ),
                      ),
                    ],
                  )
                ],
              ),
              FlatButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text("Follow"),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {},
              )
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            child: Text(item['title']?? '',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)
            ),
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10,top: 10),
            child: Image.network(item['thumbnail_pic_s']?? '', fit: BoxFit.cover,),
          ),
          Row(
            children: [
              FlatButton.icon(
                icon: Icon(Icons.favorite_outlined, color: Color(0xFF999999)),
                label: Text("998",style: TextStyle(
                    color: Color(0xFF999999)
                ),),
                onPressed: (){},
              ),
              FlatButton.icon(
                icon: Icon(Icons.comment, color: Color(0xFF999999)),
                label: Text("234",style: TextStyle(
                    color: Color(0xFF999999)
                )),
                onPressed: (){},
              ),
              FlatButton.icon(
                icon: Icon(Icons.share_rounded,color: Color(0xFF999999)),
                label: Text("234",style: TextStyle(
                    color: Color(0xFF999999)
                )),
                onPressed: (){},
              ),
            ],
          ),
        ],
      )
    );
  }
}
