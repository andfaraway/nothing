//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-05-05 17:00:44
//
import 'package:dio/dio.dart';
import 'package:nothing/public.dart';

import '../http/http.dart';
import '../model/interface_model.dart';
import 'simple_page.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Widget? homeWidget;

  final List<InterfaceModel> _interfaceList = [];

  @override
  void initState() {
    super.initState();
    initTabBar();
  }

  void initTabBar() {
    _interfaceList.add(InterfaceModel(
        tag: 1, title: '生活小窍门', page: genericPage('生活小窍门', ConstUrl.qiaomen)));
    _interfaceList.add(InterfaceModel(
        tag: 0,
        title: '黄历',
        page: huangliPage(
            '黄历',
            ConstUrl.huangli +
                '&date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}')));
    _interfaceList.add(InterfaceModel(
        tag: 2, title: '健康提示', page: genericPage('健康提示', ConstUrl.healthTips)));
    _tabController = TabController(length: _interfaceList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ///通用界面
  Widget genericPage(String title, String url) {
    return SimplePage(
        title: title,
        justify: true,
        requestCallback: () async {
          var s = await Http.get(url);
          var dataStr = s['newslist'].first['content'];
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
        requestCallback: () async {
          var s = await Http.get(url);
          Map map = s['newslist'].first;
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
    return Stack(
      children: [
        DefaultTabController(
          length: 12,
          child: TabBarView(
              controller: _tabController,
              children: _interfaceList.map((e) => e.page!).toList()),
        ),
        if (!Navigator.canPop(context))
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
    );
  }
}
