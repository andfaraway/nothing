import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/image_compression_model.dart';

import '../http/download_manager.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // final List<XFile> _list = [XFile('path', mimeType: 'image/gpeg', name: '_7ae1b074-c031-45c6-97a1-503cc069de0f.jpeg', length: 102458)];
  final List<XFile> _list = [];

  bool _dragging = false;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            50.hSizedBox,
            DropTarget(
              onDragDone: (detail) {
                setState(() {
                  _list.addAll(detail.files);
                });
              },
              onDragEntered: (detail) {
                setState(() {
                  _dragging = true;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  _dragging = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DottedBorder(
                    color: Colors.black,
                    borderType: BorderType.RRect,
                    strokeWidth: 1,
                    radius: const Radius.circular(15),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: AppSize.screenWidth - 50,
                        minWidth: 200.w,
                        maxHeight: 200.h,
                        minHeight: 200.h,
                      ),
                      decoration: BoxDecoration(
                          color: _dragging ? Colors.blueGrey : Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              final XFile? imageList = await picker.pickImage(source: ImageSource.gallery);
                              if (imageList == null) return;
                              setState(() {
                                _list.add(imageList);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(7)),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: AppImage.asset(R.iconsDownloadCloud, color: Colors.white),
                                  ),
                                  Text(
                                    '立刻上传',
                                    style: AppTextStyle.titleMedium.copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          15.hSizedBox,
                          Text(
                            '点击按钮选择要压缩的文件,或拖拽文件到此区域\n(支持WEBP，PNG或者JPEG)',
                            style: AppTextStyle.bodyMedium,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            50.sizedBoxH,
            Visibility(
              visible: _list.isNotEmpty,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: AppSize.screenWidth - 50,
                  minWidth: 200.w,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.borderColor), color: AppColor.scaffoldBackgroundColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _list.map((file) {
                    return UploadWidget(
                      controller: DownloadController(
                        DownloadModel(file: file),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UploadWidget extends StatefulWidget {
  final DownloadController controller;

  const UploadWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  late XFile file;

  final ValueNotifier<int> _fileSize = ValueNotifier(20);
  final ValueNotifier<ImageCompressionModel?> _imageCompressionModel = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    file = widget.controller.file!;

    file.length().then((value) async {
      _fileSize.value = value;
    });

    startUpload();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  Future<void> startUpload() async {
    Uint8List bytes = await file.readAsBytes();
    var s = await API.uploadFileWithBytes(
        bytes: bytes, fileName: file.name, onSendProgress: (progress) => widget.controller.progress = progress);
    print('s = ${json.encode(s)}');
    _imageCompressionModel.value = ImageCompressionModel.fromJson(s);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(child: child!),
              Flexible(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      width: 300,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: LinearProgressIndicator(
                          value: controller.progress ?? 0,
                          color: Colors.green,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ValueListenableBuilder(
                    valueListenable: _imageCompressionModel,
                    builder: (context, model, child) {
                      if (model == null) return const SizedBox.shrink();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              Tools.formatBytes(model.byteSizeAfter),
                              style: AppTextStyle.titleMedium.copyWith(color: AppColor.doneColor),
                            ),
                          ),
                          AppButton.customButton(
                            onTap: () => _download(model),
                            child: Text(
                              'download',
                              textAlign: TextAlign.end,
                              style: AppTextStyle.titleMedium.copyWith(color: AppColor.specialColor),
                            ),
                          ),
                          10.sizedBoxW,
                          Text(
                            model.ratio ?? '',
                            style: AppTextStyle.titleMedium.copyWith(fontWeight: weightBold),
                          )
                        ],
                      );
                    }),
              )
            ],
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              file.name,
              style: AppTextStyle.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          10.sizedBoxW,
          ValueListenableBuilder(
            valueListenable: _fileSize,
            builder: (context, size, child) {
              return Text(
                Tools.formatBytes(size),
                style: AppTextStyle.titleMedium.copyWith(color: AppColor.doneColor),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _download(ImageCompressionModel model) async {
    String url = '${model.serverHost}/${model.output}';
    downloadFile(url, model.fileNameBefore);
  }

  void downloadFile(String url, String fileName) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = fileName;
    anchorElement.click();
  }
}
