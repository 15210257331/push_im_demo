import 'package:flutter/material.dart';
import 'package:push_im_demo/api/news_api.dart';
import 'package:push_im_demo/pages/drawer/drawer.dart';
import 'package:push_im_demo/pages/news/news_list.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {

  Map<String, String> newsType = {
    '推荐': 'top',
    '国内': 'guonei',
    '国际': 'guoji',
    '娱乐': 'yule',
    '体育': 'tiyu',
    '军事': 'junshi',
    '科技': 'keji',
    '财经': 'caijing',
    '时尚': 'shishang',
    '游戏': 'youxi',
    '汽车': 'qiche',
    '健康': 'jiankang',
  };

  List<dynamic> newsList = [];

  TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: newsType.keys.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新闻'),
        // backgroundColor: Colors.blueAccent,
        brightness: Brightness.dark,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: newsType.keys.map((e) => Tab(text: e)).toList(),
          isScrollable: true,
          indicatorColor: Colors.red,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18, color: Colors.orange),
          unselectedLabelStyle: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
      drawer: DrawerPage(),
      body: TabBarView(
        controller: _tabController,
        children: newsType.keys.map((e) {
          return Container(
            alignment: Alignment.center,
            child: NewsList(newsType[e]),
          );
        }).toList(),
      ),
    );
  }

}
