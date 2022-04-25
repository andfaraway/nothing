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
import 'package:nothing/page/release_version.dart';
import 'package:nothing/page/say_hi.dart';
import 'package:nothing/page/setting.dart';
import 'package:nothing/page/theme_setting.dart';
import 'package:nothing/page/upload_file.dart';
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
import 'public.dart';

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
  final ValueNotifier<String?> _todayTips = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    initTabBar();

    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                '&date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}')));
    _interfaceList.add(InterfaceModel(
        tag: 2, title: '健康提示', page: genericPage('健康提示', API.healthTips)));

    _tabController = TabController(length: _interfaceList.length, vsync: this);
  }

  /// 初始化数据
  Future<void> loadData() async {
    // var list = await LocalDataUtils.get(Constants.keyFavoriteList);
    // favoriteList.clear();
    // if (list != null) {
    //   favoriteList.addAll(list.cast<String>());
    // }

    _todayTips.value = await UserAPI.getTips();
  }

  Widget todayTipsWidget() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: _todayTips,
          builder: (context, String? value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(value ?? '')],
            );
          }),
    );
  }

  ///左侧菜单
  Widget drawer(BuildContext context) {
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
                        var result = await UserAPI.addFavorite(
                            _tipsStr.value.trim().toString(),
                            source: '看着顺眼');
                        if (result != null) {
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
              Padding(
                padding: const EdgeInsets.only(
                  left: kDrawerMarginLeft,
                  right: kDrawerMarginLeft,
                ),
                child: todayTipsWidget(),
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NormalCell(
                        title:S.current.setting,
                        onTap: () {
                          AppRoutes.pushPage(context, const SettingPage());
                        },
                      )
                    ]),
              ),
              SizedBox(
                height: Screens.bottomSafeHeight,
              ),
            ],
          )),
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
    print('黄历：$url');
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
    Screens.init(context);

    return Scaffold(
      drawer: drawer(context),
      body: Stack(
        children: [
          DefaultTabController(
            length: 12,
            child: TabBarView(
                controller: _tabController,
                children: _interfaceList.map((e) => e.page!).toList()),
          ),
          Align(
            child: Padding(
              padding:
                  EdgeInsets.only(top: Screens.topSafeHeight + 5, left: 20),
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                );
              }),
            ),
            alignment: Alignment.topLeft,
          )
        ],
      ),
    );
  }
}
