//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-24 13:51:09
//
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/setting_config_model.dart';

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
    AppResponse response = await API.getSettingModule(accountType: Singleton().currentUser.accountType);
    if (response.isSuccess) {
      for (Map<String, dynamic> map in response.dataList) {
        SettingConfigModel model = SettingConfigModel.fromJson(map);
        _settingList.add(model);
      }
      setState(() {});
    }
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
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}
