import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:push_im_demo/api/news_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  final String id;

  const NewsDetail({Key key, this.id}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  dynamic newDetail;

  WebViewController _controller;

  getNewsDetail(String id) async {
    Map<String, dynamic> params = {
      'key': '1f301d9c025202c4231a2f13c27817fe',
      'uniquekey': id
    };
    newDetail = await NewsAPI.newDetail(context: context, params: params);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getNewsDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              newDetail['detail']['title'],
              textAlign: TextAlign.center,
            ),
            WebView(
              initialUrl: "",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) async {
                _controller = controller;
                final String contentBase64 = base64Encode(
                    const Utf8Encoder().convert(newDetail['content']));
                await _controller.loadUrl(
                    'data:text/html;charset=utf-8;base64,$contentBase64');
              },
            )
          ],
        ),
      ),
    );
  }
}
