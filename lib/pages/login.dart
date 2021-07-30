import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:push_im_demo/api/user_api.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/model/user_info.dart';
import 'package:push_im_demo/pages/home.dart';
import 'package:push_im_demo/utils/storage.dart';
import 'dart:convert' as convert;
import 'package:bling_extensions/bling_extensions.dart';
import 'package:video_player/video_player.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  // 展示密码
  final ValueNotifier<bool> _showPassNotifier = ValueNotifier(false);

  // 邮箱
  final TextEditingController _emailController = TextEditingController();

  // 密码
  final TextEditingController _passController = TextEditingController();

  VideoPlayerController _controller;

  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/login_bg.mp4',
    )..initialize().then(
          (value) => {
            chewieController = ChewieController(
              videoPlayerController: _controller,
              allowPlaybackSpeedChanging: false,
              showControls: false,
              autoPlay: true,
              looping: true,
            ),
        _controller.play(),
        setState(() {}),
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLastTimeContent();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 填充上次登录的账号和密码
  setLastTimeContent() async{
    String email = StorageUtil().getJSON('email') ?? '';
    String password = StorageUtil().getJSON('password') ?? '';
    _emailController.value = _emailController.value.copyWith(
      text: email,
      selection: TextSelection(baseOffset: email.length, extentOffset: email.length),
      composing: TextRange.empty,
    );
    _passController.value = _passController.value.copyWith(
      text: password,
      selection: TextSelection(baseOffset: password.length, extentOffset: password.length),
      composing: TextRange.empty,
    );
  }

  /// 执行登录操作
  Future<void> login() async {
    FocusScope.of(context).unfocus();
    String email = _emailController.text;
    String password = _passController.text;
    if (email.isBlank || password.isBlank) {
      EasyLoading.showError("账号密码不能为空");
      return;
    }
    Map<String, dynamic> params = {
      'email': email,
      'password': password,
    };
    UserInfo userInfo = await UserAPI.login(
      context: context,
      params: params,
    );
    if (userInfo != null && userInfo.id != null) {
      /// 保存用户信息
      Global.saveProfile(userInfo);
      /// 保存用户名和密码
      StorageUtil().setJSON('email', email.trim());
      StorageUtil().setJSON('password', password.trim());
      Global.navigatorKey.currentState.pushReplacement(
        MaterialPageRoute(
            builder: (context) => Home(),
            settings: RouteSettings(name: "/")
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform.scale(
                scale: _controller.value.aspectRatio /
                    MediaQuery.of(context).size.aspectRatio,
                child: Center(
                  child: Container(
                    child: _controller.value.initialized
                        ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Chewie(controller: chewieController),
                    )
                        : Container(),
                  ),
                ),
              ),
              Positioned(
                  child: Container(
                      color: Color(0x3FFFFFFF),
                      child: SafeArea(
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 30, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLogo(),
                                buildTitle(),
                                _buildLoginForm(),
                                _buildLoginBtn(),
                                buildAgreement()
                              ],
                            ),
                          ),
                        ),
                      )))
            ],
          ),
        ));
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Text(
        "Changing the way \nonline English is done",
        textAlign: TextAlign.left,
        style: TextStyle(
            height: 1.6,
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildLogo() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Image.asset("assets/images/logo.png",
          width: 160, height: 27, fit: BoxFit.cover),
    );
  }

  /// 构建登录表单区域
  Widget _buildLoginForm() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            style: TextStyle(color: Colors.white, fontSize: 15),
            onChanged: (text) {},
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(18),
              suffixIcon: Image.asset(
                "assets/images/ico_clear.png",
                scale: 1.5,
              ).onTap(() {
                _emailController.clear();
              }),
              fillColor: Color(0x33FFFFFF),
              hintText: 'Email address',
              hintStyle: TextStyle(color: Color(0x66FFFFFF)),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30), //边角为5
                ),
                borderSide: BorderSide(
                  color: Color(0x33FFFFFF), //边线颜色为白色
                  width: 1, //边线宽度为2
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white, //边框颜色为白色
                  width: 1, //宽度为5
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30), //边角为30
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ValueListenableBuilder(
            valueListenable: _showPassNotifier,
            builder: (context, flag, _) {
              return TextField(
                style: TextStyle(color: Colors.white, fontSize: 15),
                keyboardType: TextInputType.text,
                obscureText: flag ? false : true,
                controller: _passController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  suffixIcon: _buildSuffixIcon(),
                  fillColor: Color(0x33FFFFFF),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Color(0x66FFFFFF)),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30), //边角为5
                    ),
                    borderSide: BorderSide(
                      color: Color(0x33FFFFFF),
                      width: 1, //边线宽度为2
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1, //宽度为5
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30), //边角为30
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 登录按钮
  Widget _buildLoginBtn() {
    return Container(
      margin: EdgeInsets.only(),
      width: double.infinity,
      alignment: AlignmentDirectional.center,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xff7357FF),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        'Log In',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ).onTap(() => login());
  }

  /// 密码框后缀图标
  Widget _buildSuffixIcon() {
    return ValueListenableBuilder(
      valueListenable: _showPassNotifier,
      builder: (context, flag, _) {
        if (flag) {
          return Image.asset(
            "assets/images/eye_open.png",
            scale: 1.5,
          );
        } else {
          return Image.asset(
            "assets/images/eye_close.png",
            scale: 1.5,
          );
        }
      },
    ).onTap(() => _showPassNotifier.value = !_showPassNotifier.value,
        tapInterval: 100);
  }


  /// 构建用户协议
  Widget buildAgreement() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10,bottom: 40),
        alignment: Alignment.bottomCenter,
        child: Text('《用户协议》',
          textAlign: TextAlign.end,
          style: TextStyle(
              fontSize: 14,
              color: Colors.blueAccent
          ),
        ),
      ),
    );
  }
}
