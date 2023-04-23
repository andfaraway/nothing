//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-24 13:51:09
//
import 'package:nothing/model/setting_config_model.dart';
import 'package:nothing/public.dart';
import 'package:nothing/widgets/content_white_bg.dart';
import '../utils/hive_boxes.dart';
import '/public.dart';
import '../constants/singleton.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<SettingConfigModel> _settingList = [];

  @override
  void initState() {
    super.initState();
    loadData();
    Screens.updateStatusBarStyle(dark: false);
  }

  @override
  void dispose() {
    Screens.updateStatusBarStyle(dark: true);
    super.dispose();
  }

  Future<void> loadData() async {
    List<dynamic>? dataList =
        await API.getSettingModule(accountType: Singleton().currentUser.accountType);
    if (dataList == null) return;
    for (Map<String, dynamic> map in dataList) {
      SettingConfigModel model = SettingConfigModel.fromJson(map);
      _settingList.add(model);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.setting),
        ),
        body: SingleChildScrollView(
          child: ContentWhiteBg(
            child: Column(
              children: _settingList
                  .map((e) => NormalCell(
                        title: e.module!,
                        onTap: e.onTap != null
                            ? () {
                                functionWithString(context,e.onTap!)?.call();
                              }
                            : () {
                                Routes.pushNamePage(
                                    context, e.routeName ?? '',arguments: e.arguments);
                              },
                        onLongPress: e.onLongPress == null
                            ? null
                            : () {
                                functionWithString(context,e.onLongPress!)?.call();
                              },
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}

