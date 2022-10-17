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
    return Text(vm.path.isEmpty ? 'File Management' : vm.path,overflow: TextOverflow.ellipsis,
      maxLines: 2,);
  }

  @override
  Widget createContentWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_MAIN, right: MARGIN_MAIN),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: vm.files
              .map((e) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      vm.onTap(e);
                    },
                    child: SizedBox(
                      height: 44,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            e.isDir!
                                ? Image.asset(R.iconsFolder,
                                    width: 24, height: 24, color: Colors.orange)
                                : Image.asset(R.iconsFile, width: 22, height: 22),
                            10.wSizedBox,
                            Text(e.name ?? '')
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
