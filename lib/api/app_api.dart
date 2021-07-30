import 'package:flutter/material.dart';
import 'package:push_im_demo/model/update.dart';
import 'package:push_im_demo/api/http.dart';

/// 系统相关
class AppApi {
  /// 获取最新版本信息
  static Future<AppUpdateResponseEntity> update({
    @required BuildContext context,
    AppUpdateRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/app/update',
      context: context,
      params: params,
    );
    return AppUpdateResponseEntity.fromJson(response);
  }
}
