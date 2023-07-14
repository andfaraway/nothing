//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-05-05 17:00:44
//
import 'package:nothing/common/prefix_header.dart';

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

    _interfaceList.add(InterfaceModel(
        tag: 1,
        title: '生活小窍门',
        page: genericPage(title: '生活小窍门', type: InformationType.qiaomen, backgroundColor: AppColor.randomColors[0])));
    _interfaceList.add(InterfaceModel(
        tag: 0,
        title: '黄历',
        page: huangliPage(title: '黄历', type: InformationType.lunar, backgroundColor: AppColor.randomColors[1])));
    _interfaceList.add(InterfaceModel(
        tag: 2,
        title: '健康提示',
        page: genericPage(title: '健康提示', type: InformationType.healthtip, backgroundColor: AppColor.randomColors[2])));

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
  Widget genericPage({String? title, String? type, Color? backgroundColor}) {
    return SimplePage(
        title: title,
        backgroundColor: backgroundColor,
        justify: true,
        requestCallback: () async {
          AppResponse response = await API.informationApi(type);
          if (response.isSuccess) {
            var dataStr = response.dataMap['newslist'].first['content'];
            if (dataStr is String) {
              return dataStr.replaceAll('XXX', '娜娜');
            }
          }
          return '';
        });
  }

  ///黄历
  Widget huangliPage({String? title, String? type, Color? backgroundColor}) {
    return SimplePage(
        title: title,
        backgroundColor: backgroundColor,
        requestCallback: () async {
          AppResponse response = await API.informationApi(type);
          if (response.isSuccess) {
            Map map = response.dataMap['newslist'].first;
            String str = '';
            String jieri = ((map['lunar_festival'] ?? map['festival']).toString().isNotEmpty)
                ? (map['lunar_festival'] ?? map['festival']) + '\n\n'
                : '';
            str += jieri;
            String dateStr = '日期：' + map['gregoriandate'];
            String nongliStr = '${'\n农历：' + map['tiangandizhiyear']}年 ' + map['lubarmonth'] + map['lunarday'];
            String yiStr = '\n宜：' + map['fitness'];
            String jiStr = '\n忌：' + map['taboo'];
            str = dateStr + nongliStr + yiStr + jiStr;
            return str;
          }
          return '';
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        // appBar: AppWidget.appbar(title: '资讯'),
        body: Column(
          children: [
            // _subSegmentedWidget(
            //     key: _globalKey,
            //     height: _segmentH,
            //     titles: _interfaceList.map((e) => e.title).toList(),
            //     controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _interfaceList.map((e) => e.page!).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subSegmentedWidget(
      {Key? key,
      required List<String> titles,
      required TabController controller,
      AlignmentGeometry? alignment = Alignment.centerLeft,
      double? height}) {
    return Container(
      key: key,
      width: AppSize.screenWidth,
      color: context.watch<ThemesProvider>().informationBgColor,
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: AppPadding.main.left, vertical: 12.h),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 22),
        child: TabBar(
          controller: controller,
          labelColor: Colors.white,
          //选中的颜色
          labelStyle: AppTextStyle.bodyMedium,
          unselectedLabelColor: AppColor.secondlyColor,
          //未选中的颜色
          unselectedLabelStyle: AppTextStyle.bodyMedium,
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
