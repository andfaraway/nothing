import 'dart:convert';

import 'package:file_preview/file_preview.dart';
import 'package:nothing/public.dart';
import 'file_preview_vm.dart';

class FilePreviewPage extends BasePage<_FilePreviewState> {
  final dynamic arguments;
  final String? title;
  final String? url;
  const FilePreviewPage({Key? key,this.arguments,this.title,this.url}) : super(key: key);

  @override
  _FilePreviewState createBaseState() => _FilePreviewState();
}

class _FilePreviewState extends BaseState<FilePreviewVM, FilePreviewPage> {
  @override
  FilePreviewVM createVM() => FilePreviewVM(context);

  final ValueNotifier<bool> _tbsInit = ValueNotifier(false);
  final FilePreviewController controller = FilePreviewController();

  double? loadProgress;

  String? url;

  @override
  void initState() {
    super.initState();
    Map<String,dynamic> map = json.decode(widget.arguments);
    pageTitle = widget.title ?? map['title'];
    url = widget.url ?? map['url'];
    isInit();
  }

  Future<void> isInit() async{
    _tbsInit.value = await FilePreview.tbsHasInit();
    if (!_tbsInit.value) {
      _tbsInit.value = await FilePreview.initTBS();
      print("tbs init");
      return;
    }
  }

  @override
  Widget createContentWidget() {
    if(url == null) return Center(child: Text('open error:$url'),);
    return SafeArea(
      child: ValueListenableBuilder(
        builder: (context1,bool init,child) {
          if(init == false){
            return const Center(child: CircularProgressIndicator());
          }
          print('MediaQuery.of(context).padding.bottom=${MediaQuery.of(context).padding.top}');
          return FilePreviewWidget(
            controller: controller,
            width: Screens.width,
            height: Screens.height-kAppBarHeight-MediaQuery.of(context).padding.bottom,
            //path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
            path: url!,
            callBack: FilePreviewCallBack(onShow: () {
              print("文件打开成功");
            }, onDownload: (progress) {
              print("文件下载进度$progress");
            }, onFail: (code, msg) {
              print("文件打开失败 $code  $msg");
            }),
          );
        }, valueListenable: _tbsInit,
      ),
    );
  }
}
