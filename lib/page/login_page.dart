//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 09:48:35
//

import '/public.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'package:um_share_plugin/um_share_plugin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ValueNotifier<String> _username = ValueNotifier('');
  final ValueNotifier<String> _password = ValueNotifier('');

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// 是否允许登陆
  final ValueNotifier<bool> _loginButtonEnabled = ValueNotifier<bool>(false);

  /// 是否开启密码显示
  final ValueNotifier<bool> _isObscure = ValueNotifier<bool>(true);

  /// 键盘是否出现
  final ValueNotifier<bool> _keyboardAppeared = ValueNotifier<bool>(false);

  final double distance = 55.w;
  final Color textColor1 = const Color(0xFF444444);

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 88.h,
      child: MaterialButton(
          onPressed: () {
            loginButtonPressed();
          },
          color: colorLoginButton,
          child: Text(
            S.current.login,
            style: TextStyle(
                fontSize: 38.h,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(44.w)))),
    );
  }

  Future<void> loginButtonPressed() async {
    Map<String, dynamic>? map =
        await API.login(_username.value, _password.value);
    if (map != null) {
      map['userId'] = map['id'];
      Singleton().currentUser = UserInfoModel.fromJson(map);

      String registrationId = await NotificationUtils.jpush.getRegistrationID();
      API.registerNotification(
            userId: Singleton().currentUser.userId,
            pushToken: null,
            alias: NotificationUtils.setAlias(Singleton().currentUser.username),
            registrationId: registrationId,
            identifier: Singleton().currentUser.openId);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (_) => false);
        showToast("hello ${Singleton().currentUser.username}");
      }
    } else {
      showToast("登录失败");
    }
  }

  //qq登录
  Widget qqButton() {
    return GestureDetector(
      onTap: () async {
        qqLoginButtonPressed(context);
      },
      child: Image.asset(
        'images/icon_qq.png',
        width: 90.w,
        height: 90.h,
      ),
    );
  }

  Future<void> qqLoginButtonPressed(BuildContext context) async {
    //调起QQ登录
    UMShareUserInfo info =
        await UMSharePlugin.getUserInfoForPlatform(UMSocialPlatformType_QQ);
    if (info.error == null) {
      Map<String, dynamic>? map = await API.thirdLogin(
          name: info.name,
          platform: 1,
          openId: info.openid,
          icon: info.iconurl);
      print('第三方登录：$map');
      if (map != null) {
        Singleton().currentUser = UserInfoModel.fromJson(map);
        //注册通知
        String registrationId = await NotificationUtils.jpush.getRegistrationID();
        API.registerNotification(
            userId: Singleton().currentUser.userId,
            pushToken: null,
            alias: NotificationUtils.setAlias(Singleton().currentUser.username),
            registrationId: registrationId,
            identifier: Singleton().currentUser.openId);

        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (_) => false);
          showToast("hello ${Singleton().currentUser.username}");
        }
      } else {
        showToast("登录失败");
      }
    } else {
      showToast(info.error ?? '登录失败');
    }
  }

  /// 键盘弹出或收起时设置输入字段的对齐方式以防止遮挡。
  void setAlignment(BuildContext context) {
    final double inputMethodHeight = MediaQuery.of(context).viewInsets.bottom;
    if (inputMethodHeight > 1.0 && !_keyboardAppeared.value) {
      _keyboardAppeared.value = true;
    } else if (inputMethodHeight <= 1.0 && _keyboardAppeared.value) {
      _keyboardAppeared.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    //初始化第三方登录
    UMSharePlugin.init('61b81959e014255fcbb28077');
    UMSharePlugin.setPlatform(
        platform: UMSocialPlatformType_QQ, appKey: '1112081029');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _username.dispose();
    _password.dispose();
    _keyboardAppeared.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screens.init(context);

    //初始化第三方登录
    UMSharePlugin.init('61b81959e014255fcbb28077');
    UMSharePlugin.setPlatform(
        platform: UMSocialPlatformType_QQ, appKey: '1112081029');

    setAlignment(context);
    return WillPopScope(
      onWillPop: doubleBackExit,
      child: GestureDetector(
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                color: Colors.green,
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1126.h),
                  child: Center(
                    child: Text(
                      'Nothing',
                      style: TextStyle(color: Colors.white, fontSize: 54.sp),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: _keyboardAppeared,
                      builder: (_, bool isAppear, __) {
                        if (isAppear == false) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          width: double.infinity,
                          height: isAppear ? 1126.h + 100.h : 1126.h,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: distance, right: distance),
                            child: Column(
                              children: [
                                110.hSizedBox,
                                Container(
                                  width: 640.w,
                                  height: 88.h,
                                  decoration: BoxDecoration(
                                    color: colorTextFieldBackground,
                                    borderRadius: BorderRadius.circular(44.h),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: S.current.username_hint,
                                            contentPadding:
                                                EdgeInsets.only(left: 0.w),
                                          ),
                                          controller: _usernameController,
                                          textAlign: TextAlign.center,
                                          onChanged: (value) {
                                            _username.value = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                30.hSizedBox,
                                Container(
                                  width: 640.w,
                                  height: 88.h,
                                  decoration: BoxDecoration(
                                      color: colorTextFieldBackground,
                                      borderRadius:
                                          BorderRadius.circular(44.h)),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: S.current.password_hint,
                                      contentPadding:
                                          EdgeInsets.only(left: 0.w),
                                    ),
                                    controller: _passwordController,
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      _password.value = value;
                                    },
                                  ),
                                ),
                                80.hSizedBox,
                                loginButton(),
                                22.hSizedBox,
                                Row(
                                  children: [
                                    Text(
                                      S.current.sign_up,
                                      style: TextStyle(
                                          color: textColor1, fontSize: 28.h),
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      S.current.forgot_password,
                                      style: TextStyle(
                                          color: textColor1, fontSize: 28.h),
                                    )
                                  ],
                                ),
                                270.hSizedBox,
                                qqButton()
                              ],
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
