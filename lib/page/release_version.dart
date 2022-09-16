import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nothing/model/version_update_model.dart';
import 'package:nothing/public.dart';
import 'release_version_vm.dart';

class ReleaseVersion extends BasePage<_ReleaseVersionState> {
  const ReleaseVersion({Key? key}) : super(key: key);

  @override
  _ReleaseVersionState createBaseState() => _ReleaseVersionState();
}

class _ReleaseVersionState extends BaseState<ReleaseVersionVM, ReleaseVersion> {
  @override
  ReleaseVersionVM createVM() => ReleaseVersionVM(context);

  final RefreshController _controller = RefreshController();
  final ValueNotifier<bool> sendNotification = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    pageTitle = "ReleaseVersion";
  }

  @override
  List<Widget>? appBarActions() {
    // TODO: implement appBarActions
    return [
      defaultAppBarActions(
          text: S.current.save,
          onPressed: () async {
            EasyLoading.show();
            await vm.save(sendNotification.value);
          }),
    ];
  }

  @override
  Widget createContentWidget() {
    return SmartRefresher(
      controller: _controller,
      onRefresh: () async {
        await vm.getLastVersionInfo();
        _controller.refreshCompleted();
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("send notification"),
                ValueListenableBuilder(
                  builder: (context, bool send, child) {
                    return Switch(
                        value: send,
                        activeColor: ThemeColor.red,
                        onChanged: (value) {
                          sendNotification.value = value;
                        });
                  },
                  valueListenable: sendNotification,
                )
              ],
            ),
            editCell("id", vm.model?.id, (value) {
              vm.model?.id = value;
            }),
            editCell("platform", vm.model?.platform, (value) {
              vm.model?.platform = value;
            }),
            editCell("version", vm.model?.version, (value) {
              vm.model?.version = value;
            }),
            editCell("path", vm.model?.path, (value) {
              vm.model?.path = value;
            }),
            editCell("title", vm.model?.title, (value) {
              vm.model?.title = value;
            }),
            editCell("content", vm.model?.content, (value) {
              vm.model?.content = value;
            }),
            editCell("date", vm.model?.date, (value) {
              vm.model?.id = value;
            }),
          ],
        ),
      ),
    );
  }

  Widget editCell(
      String title, String? content, ValueChanged<String>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: ThemeColor.red),
        ),
        TextField(
          controller: TextEditingController(text: content),
          decoration: const InputDecoration(
            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
