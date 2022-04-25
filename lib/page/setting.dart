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
    // // 配置
    // _settingList.add(
    //     InterfaceModel(title: S.current.message, page: const MessagePage()));
    // _settingList.add(
    //     InterfaceModel(title: S.current.feedback, page: const FeedbackPage()));
    // _settingList.add(InterfaceModel(
    //     title: S.current.theme, page: ThemeSettingPage()));
    // _settingList.add(InterfaceModel(title: S.current.hi, page: const SayHi()));
    // if(currentUser.accountType == '1'){
    //   _settingList.add(
    //       InterfaceModel(title: S.current.release_version, page: const ReleaseVersion()));
    //   _settingList.add(
    //       InterfaceModel(title: S.current.upload_file, page: const UploadFile()));
    // }

    // _settingList.add(InterfaceModel(
    //     title: S.current.version_update,
    //     page: null,
    //     onTap: () async {
    //       String version = await DeviceUtils.version();
    //       Map<String, dynamic>? data =
    //           await UserAPI.checkUpdate('ios', version);
    //       if (data != null && data['update'] == true) {
    //         String url = data['path'];
    //         if (await canLaunch(url)) {
    //           await launch(url);
    //         } else {
    //           throw 'Could not launch $url';
    //         }
    //       } else {
    //         showToast('当前已是最新版本: v$version');
    //       }
    //     },
    //     onLongPress: () async {
    //       String version = await DeviceUtils.version();
    //       Map<String, dynamic>? data =
    //           await UserAPI.checkUpdate('ios', version);
    //       if (data != null) {
    //         String url = data['path'];
    //         if (await canLaunch(url)) {
    //           await launch(url);
    //         } else {
    //           throw 'Could not launch $url';
    //         }
    //       } else {
    //         showToast('请求失败');
    //       }
    //     }));
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
                  .map((e) =>
                  NormalCell(
                    title: e.module!,
                    onTap: () {
                      AppRoutes.pushNamePage(context, e.routeName ?? '');
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

  _SettingModel({Key? key, this.id, this.module, this.routeName});

  static _SettingModel fromJson(Map map) {
    return _SettingModel(
        id: map['id'].toString(), module: map['module'], routeName:
    map['route_name']);
  }
}
