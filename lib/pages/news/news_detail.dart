import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:push_im_demo/api/news_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  final String url;

  const NewsDetail({Key key, this.url}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('detail'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) async {
              _controller = controller;
              // final String contentBase64 = base64Encode(
              //     const Utf8Encoder().convert(newDetail['content']));
              // await _controller.loadUrl(
              //     'data:text/html;charset=utf-8;base64,$contentBase64');
            },
          ),
        ));
  }
}
