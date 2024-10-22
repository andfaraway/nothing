import 'dart:convert';
import 'package:file_preview/file_preview.dart';
import 'package:nothing/common/prefix_header.dart';

class FilePreviewPage extends StatefulWidget {
  final dynamic arguments;
  final String? title;
  final String? url;

  const FilePreviewPage({Key? key, this.arguments, this.title, this.url}) : super(key: key);

  @override
  State<FilePreviewPage> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreviewPage> {
  final ValueNotifier<bool> _openFileSuccess = ValueNotifier(false);
  final FilePreviewController controller = FilePreviewController();

  late Map<String, dynamic> _map;

  double? loadProgress;

  String? url;

  @override
  void initState() {
    super.initState();
    _map = json.decode(widget.arguments);
    url = widget.url ?? _map['url'];
    isInit();
  }

  Future<void> isInit() async {
    bool init = await FilePreview.tbsHasInit();
    if (!init) {
      await FilePreview.initTBS(license: '');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (url == null || url == '') {
      return Center(child: Text('open error:$url'));
    }
    return Scaffold(
      appBar: AppWidget.appbar(title: widget.title ?? _map['title']),
      body: ValueListenableBuilder(
        builder: (context1, bool openSuccess, child) {
          return Stack(
            children: [
              FilePreviewWidget(
                controller: controller,
                width: Screens.width,
                height: Screens.height - Screens.topSafeHeight,
                //path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
                path: url!,
                callBack: FilePreviewCallBack(onShow: () {
                  Log.d("文件打开成功");
                  _openFileSuccess.value = true;
                }, onDownload: (progress) {
                  Log.d("文件下载进度$progress");
                }, onFail: (code, msg) {
                  _openFileSuccess.value = false;
                  showToast('文件打开失败');
                  Log.d("文件打开失败 $code  $msg");
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
      ),
    );
  }
}
