import 'package:flutter/material.dart';
import 'package:push_im_demo/api/news_api.dart';
import 'package:push_im_demo/pages/drawer/drawer.dart';
import 'package:push_im_demo/pages/news/dynamic.dart';
import 'package:push_im_demo/pages/news/news_list.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {

  Map<String, String> newsType = {
    '动态': 'game_inf',
    '新闻': 'hot_video',
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
        title: Text('动态'),
        // backgroundColor: Colors.blueAccent,
        brightness: Brightness.dark,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: newsType.keys.map((e) => Tab(text: e)).toList(),
          isScrollable: false,
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
        children: [
          Dynamic(),
          NewsList(newsType['新闻']),
        ]
      ),
    );
  }

}
