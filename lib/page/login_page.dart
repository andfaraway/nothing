//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 09:48:35
//

import 'package:nothing/utils/notification_utils.dart';
import 'package:um_share_plugin/um_share_plugin.dart';

import '../common/prefix_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
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
      height: 44.h,
      child: MaterialButton(
          onPressed: () {
            loginButtonPressed();
          },
          color: AppColor.specialColor,
          shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(44.w))),
          child: Text(
            S.current.login,
            style: AppTextStyle.headLineMedium.copyWith(color: Colors.white),
          )),
    );
  }

  Future<void> loginButtonPressed() async {
    Map<String, dynamic>? map = await API.login(_username.value, _password.value);
    if (map != null) {
      map['userId'] = map['id'];
      Singleton().currentUser = UserInfoModel.fromJson(map);
      NotificationUtils.register();
      if (mounted) {
        Routes.pushNamedAndRemoveUntil(context, Routes.root.name);
        showToast("hello ${Singleton().currentUser.username}");
      }
    } else {
      showToast("登录失败");
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
    UMSharePlugin.setPlatform(platform: UMSocialPlatformType_QQ, appKey: '1112081029');
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
    _keyboardAppeared.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //初始化第三方登录
    // UMSharePlugin.init('61b81959e014255fcbb28077');
    // UMSharePlugin.setPlatform(platform: UMSocialPlatformType_QQ, appKey: '1112081029');

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
          backgroundColor: Colors.green,
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'nothing',
                    style: AppTextStyle.displayLarge,
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: _keyboardAppeared,
                  builder: (_, bool isAppear, __) {
                    if (isAppear == false) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(20.h), topRight: Radius.circular(20.h))),
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: distance, right: distance),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            110.hSizedBox,
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(22.h),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                                          hintText: S.current.username_hint,
                                          hintStyle: AppTextStyle.titleMedium.placeholderColor,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        style: AppTextStyle.titleMedium,
                                        controller: _usernameController,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          _username.value = value;
                                        },
                                        cursorColor: AppColor.errorColor),
                                  ),
                                ],
                              ),
                            ),
                            30.hSizedBox,
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(22.h)),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: S.current.password_hint,
                                  hintStyle: AppTextStyle.titleMedium.placeholderColor,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: AppTextStyle.titleMedium,
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
                                  style: AppTextStyle.titleMedium,
                                ),
                                Expanded(child: Container()),
                                Text(
                                  S.current.forgot_password,
                                  style: AppTextStyle.titleMedium,
                                )
                              ],
                            ),
                            55.hSizedBox,
                            _qqButton(),
                            55.hSizedBox
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //qq登录
  Widget _qqButton() {
    return GestureDetector(
      onTap: () async {
        UMShareUserInfo info = await UMSharePlugin.getUserInfoForPlatform(UMSocialPlatformType_QQ);
        if (info.error == null) {
          Map<String, dynamic>? map =
              await API.thirdLogin(name: info.name, platform: 1, openId: info.openid, icon: info.iconurl);
          print('第三方登录：$map');
          if (map != null) {
            Singleton().currentUser = UserInfoModel.fromJson(map);

            if (mounted) {
              NotificationUtils.register();
              Routes.pushNamedAndRemoveUntil(context, Routes.root.name);
              showToast("hello ${Singleton().currentUser.username}");
            }
          } else {
            showToast("登录失败");
          }
        } else {
          showToast(info.error ?? '登录失败');
        }
      },
      child: Image.asset(
        'images/icon_qq.png',
        width: 44.w,
        height: 44.h,
      ),
    );
  }
}
