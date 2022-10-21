import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:nothing/public.dart';
import 'file_management_vm.dart';

class FileManagement extends BasePage<_FileManagementState> {
  final dynamic arguments;

  const FileManagement({Key? key, this.arguments}) : super(key: key);

  @override
  _FileManagementState createBaseState() => _FileManagementState();
}

class _FileManagementState extends BaseState<FileManagementVM, FileManagement> {
  @override
  FileManagementVM createVM() => FileManagementVM(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget? getPageWidget() {
    return Text(
      vm.path.isEmpty ? 'File Management' : vm.path,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  @override
  Widget createContentWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: vm.files
            .map((model) => InkWell(
                  onTap: () {
                    vm.onTap(model);
                  },
                  onLongPress: () {
                    showSheet(context, [
                      SheetButtonModel(
                          icon: const Icon(Icons.delete_forever),
                          title: 'delete',
                          textStyle: TextStyle(color: Colors.red),
                          onTap: () async {
                            showConfirmToast(
                                context: context,
                                title: 'Delete ${model.name}',
                                onConfirm: () async {
                                  await API.deleteFile(
                                      model.catalog, model.name!);
                                });
                          }),
                      SheetButtonModel(
                          icon: Icon(Icons.edit_note),
                          title: 'change name',
                          onTap: () async {
                            showEdit(context, commitPressed: (value) async {
                              await vm.changeFile(model, value);
                            });
                          }),
                    ]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: MARGIN_MAIN, right: MARGIN_MAIN),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 44,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                model.isDir!
                                    ? Image.asset(R.iconsFolder,
                                        width: 24,
                                        height: 24,
                                        color: Colors.orange)
                                    : Image.asset(R.iconsFile,
                                        width: 22, height: 22),
                                10.wSizedBox,
                                Text(model.name ?? '')
                              ],
                            ),
                          ),
                        ),
                        1.hDivider
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
