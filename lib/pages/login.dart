import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:push_im_demo/api/user_api.dart';
import 'package:push_im_demo/global.dart';
import 'package:push_im_demo/model/user_info.dart';
import 'package:push_im_demo/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:bling_extensions/bling_extensions.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      Global.saveProfile(userInfo);
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
        body: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLogo(),
                  _buildLoginForm(),
                  buildSubmitSection(),
                  buildAgreement()
                ],
              )
            ),
          ),
        ));
  }

  /// 构建logo
  Widget buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 140, bottom: 100),
      child: Image.asset("assets/images/logo.png",
          fit: BoxFit.cover
      ),
    );
  }

  /// 构建登录表单区域
  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: Column(
        children: <Widget>[
          TextField(
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                prefixIcon: Icon(Icons.local_phone_outlined, color: Colors.black12),
                suffixIcon: Icon(Icons.close_rounded, color: Colors.black12).onTap(() {
                  _emailController.clear();
                }),
                fillColor: Color(0xffF4F4F4),
                hintText: 'email',
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15), //边角为5
                  ),
                  borderSide: BorderSide(
                    color: Colors.white, //边线颜色为白色
                    width: 1, //边线宽度为2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, //边框颜色为白色
                    width: 1, //宽度为5
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15), //边角为30
                  ),
                ),
              ),
          ),
          SizedBox(height: 30),
          ValueListenableBuilder(
            valueListenable: _showPassNotifier,
            builder: (context, flag, _) {
              return TextField(
                keyboardType: TextInputType.text,
                obscureText: flag ? false : true,
                controller: _passController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black12),
                    suffixIcon: _buildSuffixIcon(),
                    fillColor: Color(0xffF4F4F4),
                    hintText: 'password',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15), //边角为5
                      ),
                      borderSide: BorderSide(
                        color: Colors.white, //边线颜色为白色
                        width: 1, //边线宽度为2
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white, //边框颜色为白色
                        width: 1, //宽度为5
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15), //边角为30
                      ),
                    ),
                  ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 10,right: 5),
            alignment: Alignment.bottomRight,
            child: Text('忘记密码',
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 密码框后缀图标
  Widget _buildSuffixIcon() {
    return ValueListenableBuilder(
      valueListenable: _showPassNotifier,
      builder: (context, flag, _) {
        if (flag) {
          return Icon(Icons.remove_red_eye_outlined);
        } else {
          return Icon(Icons.remove_red_eye_rounded);
        }
      },
    ).onTap(() => _showPassNotifier.value = !_showPassNotifier.value,
        tapInterval: 200);
  }

  /// 构建登录按钮区域
  Widget buildSubmitSection() {
    return GestureDetector(
        onTap: () async {
          await login();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            alignment: AlignmentDirectional.center,
            width: 315,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff7357FF),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Text(
              'Log In',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
    );
  }

  /// 构建用户协议
  Widget buildAgreement() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10,bottom: 40),
        alignment: Alignment.bottomCenter,
        child: Text('《 用户协议 》',
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
