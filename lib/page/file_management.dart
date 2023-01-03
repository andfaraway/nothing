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

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget? getPageWidget() {
    return Text(
      vm.currentCatalog ?? 'File Management',
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  @override
  Widget createContentWidget() {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        await vm.loadFiles(vm.currentCatalog);
        _refreshController.refreshCompleted();
      },
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: vm.files
            .asMap()
            .map((index, model) => MapEntry(
                index,
                InkWell(
                  onTap: () {
                    vm.onTap(model);
                  },
                  onLongPress: () {
                    if (model.name == '...') return;
                    showSheet(context, [
                      SheetButtonModel(
                          icon: const Icon(Icons.open_in_new_outlined),
                          title: S.current.open,
                          onTap: () async {
                            vm.open(model,index);
                          }),
                      SheetButtonModel(
                          icon: const Icon(Icons.edit_outlined),
                          title: S.current.rename,
                          onTap: () async {
                            showEdit(context,
                                title: S.current.rename,
                                text: model.name, commitPressed: (value) async {
                              await vm.changeFile(model, value);
                            });
                          }),
                      SheetButtonModel(
                          icon: const Icon(Icons.delete_forever),
                          title: S.current.delete,
                          textStyle: const TextStyle(color: Colors.red),
                          onTap: () async {
                            showConfirmToast(
                                context: context,
                                title: '${S.current.delete} ${model.name} ?',
                                onConfirm: () async {
                                  vm.deleteFile(model);
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
                )))
            .values
            .toList(),
      ),
    );
  }
}
