import 'dart:html' as html;
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/image_compression_model.dart';

import '../http/download_manager.dart';

class ImageCompressionPage extends StatefulWidget {
  final Object? arguments;

  const ImageCompressionPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<ImageCompressionPage> createState() => _ImageCompressionPageState();
}

class _ImageCompressionPageState extends State<ImageCompressionPage> {
  // final List<XFile> _list = [XFile('path', mimeType: 'image/gpeg', name: '_7ae1b074-c031-45c6-97a1-503cc069de0f.jpeg', length: 102458)];
  // final List<DownloadController> _list = [
  //   DownloadController(DownloadModel(
  //     file: XFile('fsfda', length: 1124, name: 'test1'),
  //   )),
  //   DownloadController(DownloadModel(
  //     file: XFile('fsfda', length: 132568, name: 'test2'),
  //   )),
  // ];
  final List<DownloadController> _list = [];

  bool _dragging = false;

  final ImagePicker picker = ImagePicker();

  final ValueNotifier<int> _quality = ValueNotifier(70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.hSizedBox,
            IntrinsicWidth(
              child: ValueListenableBuilder(
                  valueListenable: _quality,
                  builder: (context, value, child) {
                    return Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('压缩系数：$value'),
                        Slider(
                          value: value.toDouble(),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onChanged: (value) {
                            _quality.value = value.round();
                          },
                          min: 0,
                          max: 100,
                        )
                      ],
                    );
                  }),
            ),
            20.hSizedBox,
            DropTarget(
              onDragDone: (detail) {
                setState(() {
                  List<DownloadController> list = detail.files
                      .map((e) => DownloadController(
                            DownloadModel(file: e),
                          ))
                      .toList();
                  _list.addAll(list);
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
                      width: Constants.isWeb ? 200.w : double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                          color:
                              _dragging ? Colors.blueGrey : Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              final XFile? file = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (file == null) return;
                              setState(() {
                                _list.add(DownloadController(
                                    DownloadModel(file: file)));
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(7)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: AppImage.asset(R.iconsUpload, color: Colors.white),
                                  ),
                                  Text(
                                    '立刻上传',
                                    style: AppTextStyle.titleMedium
                                        .copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          15.hSizedBox,
                          Text(
                            '选择要压缩的文件,或拖拽文件到此区域\n(支持WEBP，PNG或者JPEG)',
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
            30.sizedBoxH,
            Visibility(
              visible: _list.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.up,
                children: _list.map((controller) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: UploadWidget(
                      controller: controller,
                      quality: _quality.value,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UploadWidget extends StatefulWidget {
  final int quality;
  final DownloadController controller;

  const UploadWidget({Key? key, required this.controller, this.quality = 70})
      : super(key: key);

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  late XFile file;

  final ValueNotifier<int> _fileSize = ValueNotifier(20);

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
    AppResponse response = await API.imageCompress(
        bytes: bytes,
        fileName: file.name,
        quality: widget.quality,
        onSendProgress: (progress) => widget.controller.progress = progress);
    if (response.isSuccess) {
      widget.controller.imageCompressionModel =
          ImageCompressionModel.fromJson(response.dataMap);
      widget.controller.complete = true;
    } else {
      widget.controller.complete = true;
      widget.controller.imageCompressionModel = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppSize.screenWidth - 50,
        minWidth: 200.w,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.borderColor),
          color: AppColor.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(7)),
      child: ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                child!,
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _fileSize,
                      builder: (context, size, child) {
                        return Text(
                          Tools.formatBytes(size),
                          style: AppTextStyle.titleMedium
                              .copyWith(color: AppColor.errorColor),
                        );
                      },
                    ),
                    Visibility(
                      visible: controller.imageCompressionModel != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('   ->   '),
                          Text(
                            '${Tools.formatBytes(controller.imageCompressionModel?.byteSizeAfter)}        ',
                            style: AppTextStyle.titleMedium
                                .copyWith(color: AppColor.doneColor),
                          ),
                          Text(
                            controller.imageCompressionModel?.ratio ?? '',
                            style: AppTextStyle.titleMedium
                                .copyWith(fontWeight: weightBold),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: controller.complete,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: AppButton.customButton(
                            child: Text(
                              '重试',
                              style: AppTextStyle.titleMedium
                                  .copyWith(color: AppColor.specialColor),
                            ),
                            onTap: () {
                              controller.complete = false;
                              controller.imageCompressionModel = null;
                              startUpload();
                            }),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      width: 300,
                      height: 30,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: LinearProgressIndicator(
                                value: controller.progress ?? 0,
                                color: Colors.green,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  controller.imageCompressionModel == null &&
                                      controller.progress == 1 &&
                                      !controller.complete,
                              child: Text(
                                '压缩中..',
                                style: AppTextStyle.titleMedium
                                    .copyWith(color: AppColor.white),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Visibility(
                              visible: controller.imageCompressionModel != null,
                              child: AppButton.customButton(
                                onTap: () =>
                                    _download(controller.imageCompressionModel),
                                child: Text(
                                  '下载',
                                  textAlign: TextAlign.end,
                                  style: AppTextStyle.titleMedium.copyWith(
                                      color: AppColor.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Visibility(
                              visible: controller.complete &&
                                  controller.imageCompressionModel == null,
                              child: AppButton.customButton(
                                onTap: () =>
                                    _download(controller.imageCompressionModel),
                                child: Text(
                                  '失败',
                                  textAlign: TextAlign.end,
                                  style: AppTextStyle.titleMedium
                                      .copyWith(color: AppColor.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: Row(
          children: [
            Flexible(
              child: Text(
                file.name,
                style: AppTextStyle.titleMedium,
                maxLines: 2,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _download(ImageCompressionModel? model) async {
    if (model == null) return;
    String url = '${model.serverHost}/${model.output}';

    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = model.fileNameBefore;
    anchorElement.click();
  }
}
