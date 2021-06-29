import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/pages/home.dart';
import 'package:push_im_demo/pages/login.dart';
import 'package:push_im_demo/pages/splash_screen.dart';
import 'package:push_im_demo/provider/app_provider.dart';
import 'package:push_im_demo/provider/contact_provider.dart';
import 'package:push_im_demo/config.dart';
import 'package:push_im_demo/provider/im_provider.dart';

void main() async {

  await Global.init();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
          ChangeNotifierProvider<ContactProvider>(create: (_) => ContactProvider()),
          ChangeNotifierProvider<ImProvider>(create: (_) => ImProvider()),
        ],
        child: Consumer2<AppProvider, ContactProvider>(
          builder: (context, appProvider, userInfoProvider, _) {
            Color _themeColor;
            String themeColorKey = appProvider.themeColorKey;
            if (appProvider.themeColorMap[themeColorKey] != null) {
              _themeColor = appProvider.themeColorMap[themeColorKey];
            }
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              /// 同时设置 theme 和darkTheme 则跟随系统设置的深色或浅色模式自动取darkTheme或theme中的值，
              /// 两个属性现在设置的值相同 则表明不管系统如何切换都显示同一套颜色
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: _themeColor,
                cardColor: _themeColor,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: _themeColor,
                cardColor: _themeColor,
              ),
              initialRoute: "/",
              navigatorKey: Global.navigatorKey,
              home: SplashScreen(),
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



