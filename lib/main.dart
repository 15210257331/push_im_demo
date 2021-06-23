import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/home.dart';
import 'package:push_im_demo/pages/login.dart';
import 'package:push_im_demo/provider/app_provider.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/utils/config.dart';

void main() async {

  await Global.init();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
          ChangeNotifierProvider<ContactProvider>(create: (_) => ContactProvider()),
        ],
        child: Consumer2<AppProvider, ContactProvider>(
          builder: (context, appProvider, userInfoProvider, _) {
            Color _themeColor;
            String colorKey = appProvider.themeColor;
            if (themeColorMap[colorKey] != null) {
              _themeColor = themeColorMap[colorKey];
              print(_themeColor);
            }
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: _themeColor,
                cardColor: _themeColor,
                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _themeColor),
              ),
              initialRoute: "/",
              navigatorKey: Global.navigatorKey,
              home: Global.userInfo != null ? Home() : Login(),
              builder: EasyLoading.init(),
            );
          },
        ),
      )
  );

  if(Platform.isAndroid){
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
      // 设置状态栏的背景色
        statusBarColor: Colors.transparent,
        //这是设置状态栏的图标和字体的颜色
        //Brightness.light  一般都是显示为白色
        //Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}



