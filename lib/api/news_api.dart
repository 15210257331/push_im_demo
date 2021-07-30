import 'package:flutter/material.dart';
import 'package:push_im_demo/api/http.dart';

/// 新闻相关接口
class NewsAPI {
  /// 新闻列表
  static Future<dynamic> getNewsList({
    @required BuildContext context,
    dynamic params,
  }) async {
    var response = await HttpUtil().get(
      'http://v.juhe.cn/toutiao/index',
      context: context,
      params: params,
    );
    return response['result']['data'];
  }

  /// 获取新闻详情
  static Future<dynamic> newDetail({
    @required BuildContext context,
    dynamic params,
  }) async {
    var response = await HttpUtil().get(
      'http://v.juhe.cn/toutiao/content',
      context: context,
      params: params,
    );
    return response['result'];
  }
}
