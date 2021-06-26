import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:push_im_demo/model/user_info.dart';
import 'package:push_im_demo/utils/http.dart';

/// 用户相关接口
class UserAPI {
  /// 登录
  static Future<UserInfo> login({
    @required BuildContext context,
    dynamic params,
  }) async {
    EasyLoading.show(status: 'loading...');
    var response = await HttpUtil().post(
      'https://fapi-smix1.t.blingabc.com/fts/open-api/foreign/v1/app-login',
      context: context,
      params: params,
    );
    EasyLoading.dismiss();
    if(response['code'] == 10000) {
      return UserInfo.fromJson(response['data']);
    } else {
      EasyLoading.showError(response['msg']);
    }
  }
}
