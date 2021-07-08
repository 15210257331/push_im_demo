import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class FileUtils {
  /// 选择图片
  static Future getImage() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.camera,].request();
    print(statuses[Permission.camera]);
    PickedFile pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  /// 选择视频
  static Future getVideo() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.camera,].request();
    print(statuses[Permission.camera]);
    PickedFile pickedVideo = await ImagePicker().getVideo(source: ImageSource.camera); /// 从相册选择视频会有问题，不知道为啥 选出来都是图片
    if (pickedVideo != null) {
      return File(pickedVideo.path);
    } else {
      print('No video selected.');
      return null;
    }
  }

  /// 选择单个文件
  static Future getSingleFile() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.camera,].request();
    print(statuses[Permission.camera]);
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path);
      return file;
    } else {
      print('No video selected.');
      return null;
    }
  }
}


