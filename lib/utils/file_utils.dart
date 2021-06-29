import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class FileUtils {
  /// 选择图片或者视频
  static Future getFile({@required String type}) async {
    Map<Permission, PermissionStatus> statuses = await [Permission.camera,].request();
    print(statuses[Permission.camera]);
    if(type == 'image') {
      PickedFile pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        return File(pickedImage.path);
      } else {
        print('No image selected.');
        return null;
      }
    }
    if(type == 'video') {
      PickedFile pickedVideo = await ImagePicker().getVideo(source: ImageSource.camera); /// 从相册选择视频会有问题，不知道为啥 选出来都是图片
      if (pickedVideo != null) {
        return File(pickedVideo.path);
      } else {
        print('No video selected.');
        return null;
      }
    }
  }
}


