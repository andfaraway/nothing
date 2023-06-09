import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/photo_save.dart';

class PictureViewer extends StatefulWidget {
  final String? imageName;
  final String imageUrl;
  final int? imageSize;
  final int? originalImageSize;
  final GestureTapCallback? onTap;

  const PictureViewer(
      {Key? key, required this.imageUrl, this.imageName, this.imageSize, this.originalImageSize, this.onTap})
      : super(key: key);

  @override
  State<PictureViewer> createState() => _PictureViewerState();
}

class _PictureViewerState extends State<PictureViewer> {
  late String imageUrl;
  late String originalImageUrl;

  ValueNotifier<bool> btnShow = ValueNotifier(true);

  /// 原图是否缓存
  bool _imageCached = false;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
    originalImageUrl = widget.imageUrl.replaceAll("s/", "");

    // 若不含压缩标记，不显示原图按钮
    if (imageUrl == originalImageUrl) {
      btnShow.value = false;
    } else {
      showOriginalBtn();
    }
  }

  Future<void> showOriginalBtn() async {
    try {
      await DefaultCacheManager().getSingleFile(originalImageUrl);
      _imageCached = true;
      btnShow.value = false;
      Log.d("image cache");
    } catch (e) {
      Log.d("no cache");
      btnShow.value = true;
    }
  }

  void originalBtnClick() {
    setState(() {
      imageUrl = originalImageUrl;
      btnShow.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView.customChild(
          wantKeepAlive: true,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          customSize: MediaQuery.sizeOf(context),
          enableRotation: false,
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 10,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onLongPress: () {
              showSheet(context, [
                SheetButtonModel(
                    title: S.current.save,
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColor.red),
                    onTap: () async {
                      await saveNetworkImg(
                          imgUrl: imageUrl,
                          progressCallback: (current, total) {
                            EasyLoading.showProgress(current / (widget.imageSize ?? total));
                          });
                      EasyLoading.dismiss();
                    }),
                SheetButtonModel(
                    title: S.current.save_original_image,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    onTap: () async {
                      EasyLoading.show();
                      await saveNetworkImg(
                          imgUrl: imageUrl.replaceAll("s/", ""), progressCallback: (current, total) {});
                      EasyLoading.dismiss();
                    }),
                SheetButtonModel(
                    title: S.current.cancel,
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColor.blackLight),
                    bottomLine: false)
              ]);
            },
            child: CachedNetworkImage(
                imageUrl: _imageCached ? originalImageUrl : imageUrl,
                httpHeaders: const {"Connection": "keep-alive"},
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                fadeInDuration: const Duration(milliseconds: 100),
                fadeOutDuration: const Duration(milliseconds: 100),
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  double? progress = downloadProgress.downloaded / (widget.imageSize ?? 1);
                  if (imageUrl == originalImageUrl) {
                    if (widget.originalImageSize == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      progress = downloadProgress.downloaded / (widget.originalImageSize ?? 1);
                      return Center(child: CircularProgressIndicator(value: progress));
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(value: progress),
                    );
                  }
                },
                errorWidget: (context, object, _) {
                  return const LoadErrorWidget();
                }),
          ),
        ),
        ValueListenableBuilder(
          builder: (context, bool show, child) {
            if (!show) return const SizedBox.shrink();
            return Align(
              alignment: Alignment.bottomLeft,
              child: SafeArea(
                child: TextButton(
                  onPressed: () {
                    originalBtnClick();
                  },
                  child: Text(
                    "原图",
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                ),
              ),
            );
          },
          valueListenable: btnShow,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Text(
              widget.imageName ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
