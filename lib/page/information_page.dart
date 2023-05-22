//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-05-05 17:00:44
//
import 'package:nothing/common/prefix_header.dart';

import '../http/http.dart';
import '../model/interface_model.dart';
import 'simple_page.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> with SingleTickerProviderStateMixin {
  Widget? homeWidget;

  final List<InterfaceModel> _interfaceList = [];

  late final TabController _tabController;

  double _segmentH = 32.h;

  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _interfaceList.add(InterfaceModel(tag: 1, title: '生活小窍门', page: genericPage('生活小窍门', ConstUrl.qiaomen)));
    _interfaceList.add(InterfaceModel(
        tag: 0,
        title: '黄历',
        page: huangliPage('黄历', '${ConstUrl.huangli}&date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}')));
    _interfaceList.add(InterfaceModel(tag: 2, title: '健康提示', page: genericPage('健康提示', ConstUrl.healthTips)));

    _tabController = TabController(length: _interfaceList.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _segmentH = _globalKey.currentContext?.size?.height ?? _segmentH;
      setState(() {});
    });
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
          String jieri = ((map['lunar_festival'] ?? map['festival']).toString().isNotEmpty)
              ? (map['lunar_festival'] ?? map['festival']) + '\n\n'
              : '';
          str += jieri;
          String dateStr = '日期：' + map['gregoriandate'];
          String nongliStr = '\n农历：' + map['tiangandizhiyear'] + '年 ' + map['lubarmonth'] + map['lunarday'];
          String yiStr = '\n宜：' + map['fitness'];
          String jiStr = '\n忌：' + map['taboo'];
          str = dateStr + nongliStr + yiStr + jiStr;
          return str;
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '资讯',
            style: AppTextStyle.headLineMedium,
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, _segmentH),
            child: _subSegmentedWidget(
                key: _globalKey,
                height: _segmentH,
                titles: _interfaceList.map((e) => e.title).toList(),
                controller: _tabController),
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: _interfaceList.map((e) => e.page!).toList(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _subSegmentedWidget(
      {Key? key,
      required List<String> titles,
      required TabController controller,
      AlignmentGeometry? alignment = Alignment.centerLeft,
      double? height}) {
    return Container(
      key: key,
      width: AppSize.screenWidth,
      // color: AppColor.scaffoldBackgroundColor,
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: AppPadding.main.left, vertical: 7.h),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 22),
        child: TabBar(
          controller: controller,
          labelColor: Colors.white,
          //选中的颜色
          labelStyle: TS.m13c43.copyWith(fontSize: 13),
          unselectedLabelColor: AppColor.secondlyColor,
          //未选中的颜色
          unselectedLabelStyle: TS.m13c43.copyWith(fontSize: 13),
          isScrollable: true,
          indicatorPadding: EdgeInsets.symmetric(horizontal: -9.w),
          labelPadding: EdgeInsets.symmetric(horizontal: 13.w),
          indicatorWeight: 0.0,
          //自定义indicator样式
          indicator: BoxDecoration(
            color: AppColor.mainColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          // controller: TabController(length: titles.length,vsync: this),
          onTap: (value) {},
          tabs: titles
              .map((e) => Tab(
                    text: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
