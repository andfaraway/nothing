//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-04 18:13:56

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:nothing/page/information_page.dart';

import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/setting.dart';
import 'package:nothing/widgets/smart_drawer.dart';
import 'package:nothing/model/interface_model.dart';
import 'package:nothing/widgets/webview/in_app_webview.dart';

import 'simple_page.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'public.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomePage> {
  Widget? homeWidget;

  final ValueNotifier _tipsStr = ValueNotifier(null);
  final ValueNotifier<Map<String, dynamic>?> _todayTips = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    String? homePage = context.read<LaunchProvider>().launchInfo?.homePage;
    print('homePage=$homePage');
    if (homePage != null) {
      ServerTargetModel targetModel =
          ServerTargetModel.fromString(context, homePage);
      if (targetModel.type == 0) {
        homeWidget = targetModel.page;
      } else {
        homeWidget = AppWebView(
          url: targetModel.url,
          title: 'nothing',
          withAppBar: false,
        );
      }
    }
    homeWidget ??= const InformationPage();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 初始化数据
  Future<void> loadData() async {
    // var list = await LocalDataUtils.get(Constants.keyFavoriteList);
    // favoriteList.clear();
    // if (list != null) {
    //   favoriteList.addAll(list.cast<String>());
    // }
    _todayTips.value = await API.getTips();
  }

  TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 32.sp);
  TextStyle vipStyle = TextStyle(color: Colors.red, fontSize: 32.sp);

  Widget todayTipsWidget() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: _todayTips,
          builder: (context, Map<String, dynamic>? map, child) {
            if (map == null) return const SizedBox.shrink();
            String dayName1 = map['first_dic']['name'];
            int dayCount1 = map['first_dic']['days'];
            String dayStr1 = dayCount1.toString();
            String timeStr1 = '天';
            if (dayCount1 == 0) {
              double hour = map['first_dic']['seconds'] / 3600;
              dayStr1 = hour.toStringAsFixed(0);
              timeStr1 = '小时';
            }

            String dayName2 = map['second_dic']['name'];
            int dayCount2 = map['second_dic']['days'];
            String dayStr2 = dayCount2.toString();
            String timeStr2 = '天';
            if (dayCount2 == 0) {
              double hour = map['second_dic']['seconds'] / 3600;
              dayStr2 = hour.toStringAsFixed(0);
              timeStr2 = '小时';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  map['tips_name'],
                  style: TextStyle(color: Colors.black, fontSize: 32.sp),
                ),
                Text(
                  map['date_str'] + '\n',
                  style: TextStyle(color: Colors.black, fontSize: 32.sp),
                ),
                Text(
                  map['wish_str'],
                  style: TextStyle(color: Colors.black, fontSize: 32.sp),
                ),
                if (map['week_distance'] != null)
                  _holidayDistanceWidget(
                      '周末', map['week_distance'].toString(), '天'),
                _holidayDistanceWidget(dayName1, dayStr1, timeStr1),
                _holidayDistanceWidget(dayName2, dayStr2, timeStr2),
              ],
            );
          }),
    );
  }

  Widget _holidayDistanceWidget(
      String holidayName, String days, String timeStr) {
    InlineSpan span = TextSpan(children: [
      TextSpan(text: '离$holidayName还有', style: defaultStyle),
      TextSpan(text: ' $days ', style: vipStyle),
      TextSpan(text: timeStr, style: defaultStyle),
    ]);
    return Text.rich(span);
  }

  ///左侧菜单
  Widget drawer(BuildContext context) {
    return SmartDrawer(
      callback: (open) async {
        Constants.hideKeyboard(context);
        if (open) {
          _tipsStr.value ??= (await API.loadTips()).replaceAll('娶', '嫁');
          _todayTips.value = await API.getTips();
        }
      },
      child: Container(
          color: Colors.white,
          width: Screens.width * 0.8,
          child: Column(
            children: [
              Consumer<ThemesProvider>(builder: (context, provider, child) {
                return Container(
                  height: Screens.topSafeHeight + 70,
                  color: provider.currentThemeGroup.themeColor,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: kDrawerMarginLeft,
                      right: kDrawerMarginLeft,
                    ),
                    child: GestureDetector(
                      onLongPressEnd: (details) {
                        setState(() {
                          showToast("${Singleton.currentUser.username} bye");
                          LocalDataUtils.cleanData();
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (_) => false);
                          }
                        });
                      },
                      onTap: () async {
                        if (Singleton.currentUser.username != null) {
                          showToast("hello ${Singleton.currentUser.username}");
                        }
                      },
                      child: Singleton.currentUser.avatar == null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SpinKitSpinningLines(
                                duration: Duration(seconds: 5),
                                color: Colors.white.withOpacity(0.5),
                                size: 50,
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  NetworkImage(Singleton.currentUser.avatar!),
                              backgroundColor:
                                  provider.currentThemeGroup.themeColor,
                              radius: 25),
                    ),
                  ),
                );
              }),
              Consumer<ThemesProvider>(builder: (context, provider, child) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: kDrawerMarginLeft,
                        right: kDrawerMarginLeft,
                        bottom: kDrawerMarginLeft),
                    child: GestureDetector(
                      onDoubleTap: () async {
                        var result = await API.addFavorite(
                            _tipsStr.value.trim().toString(),
                            source: '看着顺眼');
                        if (result != null) {
                          showToast('收藏成功！');
                        }
                      }.throttle(),
                      child: ValueListenableBuilder(
                        valueListenable: _tipsStr,
                        builder: (context, value, child) {
                          return Text(
                            _tipsStr.value ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.start,
                          );
                        },
                      ),
                    ),
                  ),
                  color: provider.currentThemeGroup.themeColor,
                  height: 150,
                  alignment: Alignment.bottomLeft,
                );
              }),
              Padding(
                padding: const EdgeInsets.only(
                    left: kDrawerMarginLeft,
                    right: kDrawerMarginLeft,
                    top: kDrawerMarginLeft),
                child: todayTipsWidget(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    cellWidget(
                      SvgPicture.asset(
                        R.imagesZixun,
                        width: 40.w,
                        height: 40.w,
                      ),
                      S.current.information,
                      () {
                        AppRoutes.pushNamePage(
                            context, informationRoute.routeName);
                      },
                    ),
                    cellWidget(
                      SvgPicture.asset(
                        R.imagesMessage,
                        width: 40.w,
                        height: 40.w,
                      ),
                      S.current.message,
                      () {
                        AppRoutes.pushNamePage(context, messageRoute.routeName);
                      },
                    ),
                    cellWidget(
                      SvgPicture.asset(
                        R.imagesSetUp,
                        width: 40.w,
                        height: 40.w,
                      ),
                      S.current.setting,
                      () {
                        AppRoutes.pushPage(context, const SettingPage());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Screens.bottomSafeHeight,
              ),
            ],
          )),
    );
  }

  /// 菜单设置栏
  Widget cellWidget(Widget icon, String title, GestureTapCallback? onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 85.h,
        child: Padding(
          padding: EdgeInsets.only(left: kDrawerMarginLeft, right: kDrawerMarginLeft),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              30.wSizedBox,
              Expanded(
                  child: Text(
                title,
                style: themeTextStyle(fontSize: 32.sp),
              )),
              // const Icon(
              //   Icons.keyboard_arrow_right,
              //   size: 22,
              //   color: Color(0xFFC8C8C8),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Screens.init(context);
    return Scaffold(
      drawer: drawer(context),
      body: homeWidget!,
    );
  }
}
