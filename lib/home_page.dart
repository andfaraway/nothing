//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-04 18:13:56

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nothing/page/favorite_page.dart';
import 'package:nothing/page/feedback_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/page/photo_show.dart';
import 'package:nothing/page/say_hi.dart';
import 'package:nothing/page/theme_setting.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'package:nothing/widgets/check_update_widget.dart';
import 'package:nothing/widgets/smart_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';
import 'package:nothing/top_news.dart';
import 'package:nothing/model/interface_model.dart';

import 'simple_page.dart';

import 'package:um_share_plugin/um_share_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<InterfaceModel> _interfaceList = [];
  final ValueNotifier _tipsStr = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    initTabBar();

    loadData();
  }

  initTabBar() {
    _interfaceList.add(InterfaceModel(
        tag: 1, title: '生活小窍门', page: genericPage('生活小窍门', API.qiaomen)));

    _interfaceList.add(InterfaceModel(
        tag: 0,
        title: '黄历',
        page: huangliPage(
            '黄历',
            API.huangli +
                '&date=${DateFormat('yyyyy-MM-DD').format(DateTime.now())}')));
    _interfaceList.add(InterfaceModel(
        tag: 2, title: '健康提示', page: genericPage('生活小窍门', API.healthTips)));
    // _interfaceList
    //     .add(InterfaceModel(tag: 3, title: '❤️娜娜❤️', url: API.caihongpi));
    // _interfaceList.add(InterfaceModel(
    //     tag: 4,
    //     title: '今日头条',
    //     page: TopNewsPage(
    //         title: '今日头条',
    //         backgroundColor: getRandomColor(),
    //         requestCallback: () async {
    //           Response s = await NetUtils.get(API.topNews);
    //           var data = s.data['newslist'];
    //           return data;
    //         })));

    _interfaceList.add(InterfaceModel(
        tag: 5, title: S.current.message, page: const MessagePage()));
    _interfaceList.add(InterfaceModel(
        tag: 6, title: S.current.feedback, page: const FeedbackPage()));
    // _interfaceList.add(InterfaceModel(tag: 5, title: '通知', url: API.topNews));
    _tabController = TabController(length: _interfaceList.length, vsync: this);
  }

  /// 初始化数据
  Future<void> loadData() async {
    // var list = await LocalDataUtils.get(Constants.keyFavoriteList);
    // favoriteList.clear();
    // if (list != null) {
    //   favoriteList.addAll(list.cast<String>());
    // }
  }

  ///左侧菜单
  drawer(BuildContext context) {
    return SmartDrawer(
      callback: (open) async {
        Constants.hideKeyboard(context);
        if (open) {
          _tipsStr.value ??= (await API.loadTips()).replaceAll('娶', '嫁');
        }
      },
      child: Container(
        color: Colors.white,
        width: Screens.width * 0.8,
        child: Builder(builder: (context) {
          return Column(
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
                                backgroundColor: provider.currentThemeGroup.themeColor,
                                radius: 25),
                      ),
                    ),
                  );
                }
              ),
              Consumer<ThemesProvider>(builder: (context, provider, child) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: kDrawerMarginLeft,
                        right: kDrawerMarginLeft,
                        bottom: kDrawerMarginLeft),
                    child: GestureDetector(
                      onTap: () async {
                        var result = await UserAPI.addFavorite(_tipsStr.value.trim().toString(),source: '看着顺眼');
                        if(result != null){
                          showToast('收藏成功！');
                        }
                        // String text = _tipsStr.value.trim().toString();
                        // if (!favoriteList.contains(text)) {
                        //   favoriteList.add(text);
                        //   bool s = await LocalDataUtils.setStringList(
                        //       Constants.keyFavoriteList, favoriteList);
                        //   if (s) {
                        //     showToast('眼光不错哦！');
                        //   } else {
                        //     showToast('no~');
                        //   }
                        // } else {}
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
              ..._interfaceList
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _tabController.animateTo(key,
                              duration: Duration.zero);
                        },
                        child: ListTile(
                          title: value.tag == 3
                              ? Consumer<ThemesProvider>(
                                  builder: (context, provider, child) {
                                    return Text(
                                      value.title ?? '',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: provider
                                              .currentThemeGroup.themeColor),
                                    );
                                  },
                                )
                              : Text(
                                  value.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      )))
                  .values
                  .toList(),
              ListTile(
                title: const Text(
                  '收藏',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FavoritePage()));
                },
              ),
              ListTile(
                title: Text(
                  S.current.theme,
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ThemeSettingPage(S.current.theme),
                    ),
                  );
                },
              ),
              // ListTile(
              //   title: const Text(
              //     '奇怪的东西',
              //     style: TextStyle(fontSize: 18),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const PhotoShow(),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                title: const Text(
                  'hi',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SayHi(),
                    ),
                  );
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: currentDay(context),
                    ),
                    SizedBox(
                      height: Screens.bottomSafeHeight,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// 当前日期问候
  Widget currentDay(BuildContext context) {
    String hello = '你好';
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    if (hour >= 0 && hour < 6) {
      hello = '深夜了，注意休息';
    } else if (hour >= 6 && hour < 8) {
      hello = '早上好';
    } else if (hour >= 8 && hour < 11) {
      hello = '上午好';
    } else if (hour >= 11 && hour < 14) {
      hello = '中午好';
    } else if (hour >= 14 && hour < 18) {
      hello = '下午好';
    } else if (hour >= 18 && hour < 20) {
      hello = '傍晚好';
    } else if (hour >= 20 && hour <= 24) {
      hello = '晚上好';
    }

    int currentWeek = now.weekday;
    late String weekString = '一';
    switch (currentWeek) {
      case 1:
        weekString = '一';
        break;
      case 2:
        weekString = '二';
        break;
      case 3:
        weekString = '三';
        break;
      case 4:
        weekString = '四';
        break;
      case 5:
        weekString = '五';
        break;
      case 6:
        weekString = '六';
        break;
      case 7:
        weekString = '日';
        break;
    }

    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(text: '$hello，'),
          const TextSpan(text: '今天是'),
          TextSpan(
            text: '${DateFormat('MM月dd日').format(now)}，',
          ),
          TextSpan(
            text: '星期$weekString',
          ),
          if (currentWeek < 5)
            TextSpan(children: <InlineSpan>[
              const TextSpan(text: ', 距离周五还有'),
              TextSpan(
                text: '${5 - currentWeek.abs()}',
                style: TextStyle(
                  color: currentThemeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '天'),
            ]),
          const TextSpan(
            text: '❤️',
          ),
        ],
        style: context.textTheme.bodyText2?.copyWith(
          fontSize: 18,
        ),
      ),
      textAlign: TextAlign.justify,
    );
  }

  ///通用界面
  Widget genericPage(String title, String url) {
    return SimplePage(
        title: title,
        backgroundColor: getRandomColor(),
        justify: true,
        requestCallback: () async {
          Response s = await NetUtils.get(url);
          var dataStr = s.data['newslist'].first['content'];
          if (dataStr is String) {
            return dataStr.replaceAll('XXX', '娜娜');
          }

          return s.data.toString();
        });
  }

  ///黄历
  Widget huangliPage(String title, String url) {
    return SimplePage(
        title: title,
        backgroundColor: getRandomColor(),
        requestCallback: () async {
          Response s = await NetUtils.get(url);
          Map map = s.data['newslist'].first;
          String str = '';
          String jieri =
              ((map['lunar_festival'] ?? map['festival']).toString().isNotEmpty)
                  ? (map['lunar_festival'] ?? map['festival']) + '\n\n'
                  : '';
          str += jieri;
          String dateStr = '日期：' + map['gregoriandate'];
          String nongliStr = '\n农历：' +
              map['tiangandizhiyear'] +
              '年 ' +
              map['lubarmonth'] +
              map['lunarday'];
          String yiStr = '\n宜：' + map['fitness'];
          String jiStr = '\n忌：' + map['taboo'];
          str = dateStr + nongliStr + yiStr + jiStr;
          return str;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      body: DefaultTabController(
        length: 12,
        child: TabBarView(
            controller: _tabController,
            children: _interfaceList.map((e) => e.page).toList()),
      ),
    );
  }
}
