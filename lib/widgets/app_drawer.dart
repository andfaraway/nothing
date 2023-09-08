import 'package:nothing/common/prefix_header.dart';

import '../model/setting_config_model.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return Container(
        width: AppSize.screenWidth * 0.87,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        margin: EdgeInsets.only(right: 11.w),
        decoration: BoxDecoration(
          color: HexColor.fromHex('#FFFAF4F0'),
          boxShadow: [
            BoxShadow(
                blurRadius: 2, //阴影范围
                spreadRadius: 0.1, //阴影浓度
                color: Colors.grey.withOpacity(0.2)),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(11.r),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(Singleton().currentUser.avatar ?? ''), radius: 25),
                    15.wSizedBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Singleton().currentUser.nickname ?? '',
                            style: AppTextStyle.titleMedium.copyWith(letterSpacing: .1, fontWeight: weightBold),
                          ),
                          Text(
                            'my love',
                            style: AppTextStyle.bodySmall.copyWith(letterSpacing: .1),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          _loadData(force: true);
                        },
                        child: const Icon(Icons.refresh))
                  ],
                ),
              ),
              _beautifulWords(homeProvider.drawerTitle),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(11.r),
                child: _todayTipsWidget(homeProvider.drawerContent),
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: homeProvider.drawerSettings.map((e) {
                          return _cellWidget(
                            icon: (e.icon?.isEmpty == null || e.icon?.isEmpty == true)
                                ? null
                                : CachedNetworkImage(
                                    imageUrl: e.icon!,
                                    errorWidget: (context, string, child) => const SizedBox.shrink(),
                                  ),
                            title: e.module ?? '',
                            onTap: e.onTap != null
                                ? () {
                                    functionWithString(context, e.onTap!)?.call();
                                  }
                                : () {
                                    AppRoute.pushNamePage(context, e.routeName ?? '', arguments: e.arguments);
                                  },
                            onLongPress: e.onLongPress == null
                                ? null
                                : () {
                                    functionWithString(context, e.onLongPress!)?.call();
                                  },
                          );
                        }).toList(),
                      ),
                      _cellWidget(
                        icon: AppImage.asset(
                          R.imagesSetUp,
                          width: 40.w,
                          height: 40.w,
                        ),
                        title: S.current.setting,
                        onTap: () {
                          AppRoute.pushNamePage(context, AppRoute.setting.name);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _beautifulWords(String text) {
    text = text.trim();
    return Container(
      // color: ,
      // height: 150,
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 11.r, right: 11.r, bottom: 11.r),
        child: GestureDetector(
          onDoubleTap: () async {
            AppResponse response = await API.addFavorite(text, source: '看着顺眼');
            if (response.isSuccess) {
              showToast('收藏成功！');
            }
          }.throttle(),
          child: Text(
            text,
            style: AppTextStyle.titleMedium,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  Widget _todayTipsWidget(Map<String, dynamic> map) {
    if (map.isEmpty) return const SizedBox.shrink();
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

    String date1 = map['first_dic']['date'];
    String date2 = map['second_dic']['date'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          map['tips_name'],
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
        Text(
          map['date_str'] + '\n',
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
        Text(
          map['wish_str'],
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
        if (map['week_distance'] != null) _holidayDistanceWidget('周末', '', map['week_distance'].toString(), '天'),
        _holidayDistanceWidget(dayName1, date1, dayStr1, timeStr1),
        _holidayDistanceWidget(dayName2, date2, dayStr2, timeStr2),
      ],
    );
  }

  Widget _holidayDistanceWidget(String holidayName, String date, String days, String timeStr) {
    TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 16.sp);
    TextStyle vipStyle = TextStyle(color: Colors.red, fontSize: 16.sp);

    InlineSpan span = TextSpan(children: [
      TextSpan(text: '离$holidayName$date还有', style: defaultStyle),
      TextSpan(text: ' $days ', style: vipStyle),
      TextSpan(text: timeStr, style: defaultStyle),
    ]);
    return Text.rich(span);
  }

  Widget _cellWidget({Widget? icon, String? title, GestureTapCallback? onTap, GestureLongPressCallback? onLongPress}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.all(11.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 24, height: 24, child: icon),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Text(
              title ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            )),
          ],
        ),
      ),
    );
  }

  /// 初始化数据
  Future<void> _loadData({bool force = false}) async {
    HomeProvider provider = context.read<HomeProvider>();

    if (provider.drawerSettings.isEmpty || force) {
      await API.getSettingModule(accountType: Singleton().currentUser.accountType).then((response) {
        if (response.isSuccess) {
          List<SettingConfigModel> settingList = [];
          for (Map<String, dynamic> map in response.dataList) {
            SettingConfigModel model = SettingConfigModel.fromJson(map);
            if (model.drawer == null) continue;
            settingList.add(model);
          }
          settingList.sort((a, b) => a.drawer!.compareTo(b.drawer!));
          provider.drawerSettings = settingList;
        }
      });
    }

    if (provider.drawerTitle.isEmpty || force) {
      API.getLoveTips().then((response) {
        if (response.isSuccess) {
          provider.drawerTitle = response.dataMap['newslist'].first['content']?.replaceAll('娶', '嫁');
        }
      });
    }

    if (provider.drawerContent.isEmpty || force) {
      API.getTips().then((response) {
        if (response.isSuccess) {
          provider.drawerContent = response.dataMap;
        }
      });
    }
  }
}
