//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 09:48:35
//

import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:um_share_plugin/um_share_plugin.dart';

import '../common/prefix_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// 键盘是否出现
  final ValueNotifier<bool> _keyboardAppeared = ValueNotifier<bool>(false);

  final double distance = 55.w;
  final Color textColor1 = const Color(0xFF444444);

  String loginErrorText = '';

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: MaterialButton(
          onPressed: () {
            loginButtonPressed();
          },
          color: AppColor.mainColor,
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
          ),
          child: Text(
            S.current.login,
            style: AppTextStyle.headLineMedium.copyWith(color: Colors.white),
          )),
    );
  }

  Future<void> loginButtonPressed() async {
    AppResponse response = await API.login(username: _usernameController.text, password: _passwordController.text);
    if (response.isSuccess) {
      Handler.accessToken = response.dataMap['access_token'];
      Handler.refreshToken = response.dataMap['refresh_token'];
      String? nickName = response.dataMap['nick_name'];
      NotificationUtils.register();
      if (mounted) {
        AppRoute.pushNamedAndRemoveUntil(context, AppRoute.root.name);
        if (nickName != null) {
          showToast("hello $nickName");
        }
      }
    } else {
      loginErrorText = response.msg ?? '';
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      //初始化第三方登录
      UMSharePlugin.init('61b81959e014255fcbb28077');
      UMSharePlugin.setPlatform(platform: UMSocialPlatformType_QQ, appKey: '1112081029');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _keyboardAppeared.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) async {
        if (pop) {
          if (await doubleBackExit()) {
            exit(0);
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(R.imagesLoginBg), // 替换为你的实际图片路径
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Lottie.asset(
                  R.lottieLogin,
                  width: double.infinity,
                  // height: 120,
                  repeat: true,
                ),
              ),
              Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    children: [
                      30.hSizedBox,
                      Text(
                        'nothing',
                        style: GoogleFonts.shantellSans(
                          fontSize: 55,
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _keyboardAppeared,
                          builder: (_, bool isAppear, __) {
                            if (isAppear == false) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                            return Padding(
                              padding: EdgeInsets.only(left: distance, right: distance),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  110.hSizedBox,
                                  TextField(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'username',
                                      contentPadding: const EdgeInsets.only(left: 18),
                                      error: loginErrorText.isEmpty ? null : const SizedBox.shrink(),
                                    ),
                                    style: AppTextStyle.titleMedium,
                                    controller: _usernameController,
                                    cursorColor: AppColor.errorColor,
                                  ),
                                  30.hSizedBox,
                                  TextField(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'password',
                                      contentPadding: const EdgeInsets.only(left: 18),
                                      error: loginErrorText.isEmpty
                                          ? null
                                          : Text(
                                              loginErrorText,
                                              style: const TextStyle(
                                                color: AppColor.red,
                                              ),
                                            ),
                                    ),
                                    obscureText: true,
                                    obscuringCharacter: '*',
                                    style: AppTextStyle.titleMedium,
                                    controller: _passwordController,
                                  ),
                                  30.hSizedBox,
                                  loginButton(),
                                  _registerWidget(),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: _thirdButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerWidget() {
    return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: Row(
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
    );
  }

  //qq登录
  Widget _thirdButtons() {
    if (!Constants.isIOS) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      child: GestureDetector(
        onTap: () async {
          UMShareUserInfo info = await UMSharePlugin.getUserInfoForPlatform(UMSocialPlatformType_QQ);
          if (info.error == null) {
            AppResponse response =
                await API.thirdLogin(name: info.name, platform: 1, openId: info.openid, icon: info.iconurl);
            if (response.isSuccess) {
              Handler.accessToken = response.dataMap['access_token'];
              Handler.refreshToken = response.dataMap['refresh_token'];
              String? nickName = response.dataMap['nick_name'];
              if (mounted) {
                NotificationUtils.register();
                AppRoute.pushNamedAndRemoveUntil(context, AppRoute.root.name);
                showToast("hello $nickName");
              }
            } else {
              showToast("登录失败");
            }
          } else {
            showToast(info.error ?? '登录失败');
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            R.imagesIconQq,
            width: 24.w,
            height: 24.h,
          ),
        ),
      ),
    );
  }
}
