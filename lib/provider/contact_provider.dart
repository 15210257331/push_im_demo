import 'package:flutter/material.dart';
import 'package:push_im_demo/model/contact.dart';


class ContactProvider with ChangeNotifier {

  // 联系人列表
  List<ContactData>  contactList = [];

  // 联系人消息

  List<String> letters = ['A', 'B','C','D', 'E','F','G', 'H','I','J', 'K','L','M', 'N','O','P', 'Q','R','S', 'T','U','V', 'W','X','Y', 'Z'];

  // 获取联系人信息
  // Future<void> getContactList() async {
  //   BaseBean res = await HttpManager.getInstance().get(Api.contactList, queryParameters: {"headmasterId": UserInfoProvider.instance.userInfo?.id?.toString()});
  //   if(res.code == 10000) {
  //     res.data.forEach((item) {
  //       contactList.add(ContactData.fromJson(item));
  //     });
  //   }
  //   notifyListeners();
  // }
}
