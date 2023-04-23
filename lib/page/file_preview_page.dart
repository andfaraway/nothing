import 'dart:convert';

import 'package:file_preview/file_preview.dart';
import 'package:nothing/prefix_header.dart';

import 'file_preview_vm.dart';

class FilePreviewPage extends BasePage<_FilePreviewState> {
  final dynamic arguments;
  final String? title;
  final String? url;

  const FilePreviewPage({Key? key, this.arguments, this.title, this.url})
      : super(key: key);

  @override
  _FilePreviewState createBaseState() => _FilePreviewState();
}

class _FilePreviewState extends BaseState<FilePreviewVM, FilePreviewPage> {
  @override
  FilePreviewVM createVM() => FilePreviewVM(context);

  final ValueNotifier<bool> _openFileSuccess = ValueNotifier(false);
  final FilePreviewController controller = FilePreviewController();

  double? loadProgress;

  String? url;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> map = json.decode(widget.arguments);
    pageTitle = widget.title ?? map['title'];
    url = widget.url ?? map['url'];
    isInit();
  }

  Future<void> isInit() async {
    bool init = await FilePreview.tbsHasInit();
    if (!init) {
      await FilePreview.initTBS();
      return;
    }
  }

  @override
  Widget createContentWidget() {
    if (url == null || url == '') {
      return Center(child: Text('open error:$url'));
    }
    return ValueListenableBuilder(
      builder: (context1, bool openSuccess, child) {
        return Stack(
          children: [
            FilePreviewWidget(
              controller: controller,
              width: Screens.width,
              height: Screens.height - kAppBarHeight,
              //path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
              path: url!,
              callBack: FilePreviewCallBack(onShow: () {
                print("文件打开成功");
                _openFileSuccess.value = true;
              }, onDownload: (progress) {
                print("文件下载进度$progress");
              }, onFail: (code, msg) {
                _openFileSuccess.value = false;
                showToast('文件打开失败');
                print("文件打开失败 $code  $msg");
              }),
            ),
            if (!openSuccess)
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()))
          ],
        );
      },
      valueListenable: _openFileSuccess,
    );
  }
}
