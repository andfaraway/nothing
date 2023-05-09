import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/extensions/function_extension.dart';
import 'package:nothing/widgets/smart_drawer.dart';

import '../model/setting_config_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ValueNotifier<String?> _tipsStr = ValueNotifier(null);
  final ValueNotifier<Map<String, dynamic>?> _todayTips = ValueNotifier(null);

  // 菜单快捷配置
  final ValueNotifier<List<SettingConfigModel>> drawerConfigList = ValueNotifier([]);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tipsStr.dispose();
    _todayTips.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartDrawer(
      callback: (open) async {
        if (open) {
          _tipsStr.value ??= (await API.loadTips()).replaceAll('娶', '嫁');
          _todayTips.value = await API.getTips();
        }
      },
      widthPercent: 0.69,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Consumer<ThemesProvider>(builder: (context, provider, child) {
              return Container(
                color: provider.currentThemeGroup.themeColor,
                child: Column(
                  children: [
                    Container(
                      height: Screens.topSafeHeight + 70,
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: kDrawerMarginLeft,
                          right: kDrawerMarginLeft,
                        ),
                        child: GestureDetector(
                          onLongPressEnd: (details) {
                            setState(() {
                              showToast("${Singleton().currentUser.username} bye");
                              Handler.userLogout();
                            });
                          },
                          onTap: () async {
                            if (Singleton().currentUser.username != null) {
                              showToast("hello ${Singleton().currentUser.username}");
                            }
                          },
                          child: Singleton().currentUser.avatar == null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: SpinKitSpinningLines(
                                    duration: const Duration(seconds: 5),
                                    color: Colors.white.withOpacity(0.5),
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(Singleton().currentUser.avatar!),
                                  backgroundColor: provider.currentThemeGroup.themeColor,
                                  radius: 25),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: kDrawerMarginLeft, right: kDrawerMarginLeft, bottom: kDrawerMarginLeft),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            var result = await API.addFavorite(_tipsStr.value.toString().trim(), source: '看着顺眼');
                            if (result != null) {
                              showToast('收藏成功！');
                            }
                          }.throttle(),
                          child: ValueListenableBuilder(
                            valueListenable: _tipsStr,
                            builder: (context, value, child) {
                              return Text(
                                _tipsStr.value ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 22),
                                textAlign: TextAlign.start,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(
                  left: kDrawerMarginLeft, right: kDrawerMarginLeft, top: kDrawerMarginLeft, bottom: kDrawerMarginLeft),
              child: todayTipsWidget(),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: drawerConfigList,
                        builder: (context, List<SettingConfigModel> list, child) {
                          return Column(
                            children: list.map((e) {
                              return cellWidget(
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
                                        Routes.pushNamePage(context, e.routeName ?? '', arguments: e.arguments);
                                      },
                                onLongPress: e.onLongPress == null
                                    ? null
                                    : () {
                                        functionWithString(context, e.onLongPress!)?.call();
                                      },
                              );
                            }).toList(),
                          );
                        }),
                    cellWidget(
                      icon: AppImage.asset(
                        R.imagesSetUp,
                        width: 40.w,
                        height: 40.w,
                      ),
                      title: S.current.setting,
                      onTap: () {
                        Routes.pushNamePage(context, Routes.setting.name);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Screens.bottomSafeHeight,
            ),
          ],
        ),
      ),
    );
  }

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
                if (map['week_distance'] != null)
                  _holidayDistanceWidget('周末', '', map['week_distance'].toString(), '天'),
                _holidayDistanceWidget(dayName1, date1, dayStr1, timeStr1),
                _holidayDistanceWidget(dayName2, date2, dayStr2, timeStr2),
              ],
            );
          }),
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

  /// 菜单设置栏
  Widget cellWidget({Widget? icon, String? title, GestureTapCallback? onTap, GestureLongPressCallback? onLongPress}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDrawerMarginLeft, vertical: 8),
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
  Future<void> loadData() async {
    _todayTips.value = await API.getTips();

    List<dynamic> dataList = await API.getSettingModule(accountType: Singleton().currentUser.accountType) ?? [];
    List<SettingConfigModel> settingList = [];
    for (Map<String, dynamic> map in dataList) {
      SettingConfigModel model = SettingConfigModel.fromJson(map);
      if (model.drawer == null) continue;
      settingList.add(model);
    }
    settingList.sort((a, b) => a.drawer!.compareTo(b.drawer!));
    drawerConfigList.value = settingList;
  }
}
