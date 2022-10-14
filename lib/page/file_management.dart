import 'package:nothing/public.dart';
import 'file_management_vm.dart';

class FileManagement extends BasePage<_FileManagementState> {

  final dynamic arguments;

  const FileManagement({Key? key,this.arguments}) : super(key: key);

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
    pageTitle = "FileManagement";
  }

  @override
  Widget createContentWidget() {
    return Column(
      children: [

      ],
    );
  }
}