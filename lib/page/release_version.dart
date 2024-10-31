import 'package:nothing/common/prefix_header.dart';

import '../model/version_update_model.dart';

class ReleaseVersion extends StatefulWidget {
  const ReleaseVersion({Key? key}) : super(key: key);

  @override
  State<ReleaseVersion> createState() => _ReleaseVersionState();
}

class _ReleaseVersionState extends State<ReleaseVersion> {
  final AppRefreshController _controller = AppRefreshController(autoRefresh: true);
  final ValueNotifier<bool> sendNotification = ValueNotifier(false);

  VersionUpdateModel? model;
  String? tempId;

  @override
  void initState() {
    super.initState();
    getLastVersionInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    sendNotification.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Release Version',
        actions: [
          AppButton.button(
            padding: AppPadding.main,
            child: Text(
              S.current.save,
              style: AppTextStyle.titleMedium
                  .copyWith(color: context.watch<ThemesProvider>().currentThemeGroup.themeColor.adaptiveColor),
            ),
            onTap: () async {
              await save(sendNotification.value);
            },
          ),
        ],
      ),
      body: AppRefresher(
        controller: _controller,
        onRefresh: () async {
          await getLastVersionInfo();
          _controller.completed();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Row(
                children: [
                  const Expanded(child: Text("send notification")),
                  ValueListenableBuilder(
                    builder: (context, bool send, child) {
                      return Switch(
                          value: send,
                          // inactiveThumbColor:AppColor.doneColor,
                          activeColor: AppColor.red,
                          inactiveTrackColor: AppColor.underwayColor,
                          onChanged: (value) {
                            sendNotification.value = value;
                          });
                    },
                    valueListenable: sendNotification,
                  )
                ],
              ),
              editCell("id", model?.id, (value) {
                model?.id = value;
              }),
              editCell("platform", model?.platform, (value) {
                model?.platform = value;
              }),
              editCell("version", model?.version, (value) {
                model?.version = value;
              }),
              editCell("path", model?.path, (value) {
                model?.path = value;
              }),
              editCell("title", model?.title, (value) {
                model?.title = value;
              }),
              editCell("content", model?.content, (value) {
                model?.content = value;
              }),
              editCell("date", model?.date, (value) {
                model?.id = value;
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget editCell(String title, String? content, ValueChanged<String>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColor.red),
        ),
        TextField(
          controller: TextEditingController(text: content),
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> save(bool sendNotification) async {
    if (model == null) return;
    if (tempId == model!.id) {
      await API.updateVersionInfo(model!);
    } else {
      await API.addVersionInfo(model!);
    }
    if (sendNotification) {
      await API.versionUpdateNotification(model!);
    }
    showToast(S.current.success);
  }

  Future<void> updateVersionInfo() async {
    if (model == null) return;
    AppResponse response = await API.addVersionInfo(model!);
    if (response.isSuccess) {
      showToast(S.current.success);
    }
  }

  /// 检查更新
  Future<void> getLastVersionInfo() async {
    AppResponse response = await API.checkUpdate();
    if (response.isSuccess) {
      model = VersionUpdateModel.fromJson(response.dataMap);
      tempId = model?.id;
      setState(() {});
    }
  }
}
