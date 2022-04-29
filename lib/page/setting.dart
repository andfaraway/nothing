//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-24 13:51:09
//
import 'package:nothing/public.dart';
import 'package:nothing/widgets/content_white_bg.dart';
import '../api/user_api.dart';
import '../constants/singleton.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<_SettingModel> _settingList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<dynamic>? dataList =
        await UserAPI.getSettingModule(accountType: currentUser.accountType);
    if (dataList == null) return;
    for (Map<String, dynamic> map in dataList) {
      _SettingModel model = _SettingModel.fromJson(map);
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
                                functionWithString(e.onTap!)?.call();
                              }
                            : () {
                                AppRoutes.pushNamePage(
                                    context, e.routeName ?? '');
                              },
                        onLongPress: e.onLongPress == null
                            ? null
                            : () {
                                functionWithString(e.onLongPress!)?.call();
                              },
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}

class _SettingModel {
  final String? id;
  final String? module;
  final String? routeName;
  final String? onTap;
  final String? onLongPress;

  _SettingModel(
      {this.id, this.module, this.routeName, this.onTap, this.onLongPress});

  static _SettingModel fromJson(Map map) {
    return _SettingModel(
        id: map['id'].toString(),
        module: map['module'],
        routeName: map['route_name'],
        onTap: map['onTap'],
        onLongPress: map['onLongPress']);
  }
}
