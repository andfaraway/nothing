import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nothing/public.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/photo_save.dart';

class PictureViewer extends StatefulWidget {
  final String imageUrl;
  final int? imageSize;
  final GestureTapCallback? onTap;

  const PictureViewer(
      {Key? key, required this.imageUrl, this.imageSize, this.onTap})
      : super(key: key);

  @override
  State<PictureViewer> createState() => _PictureViewerState();
}

class _PictureViewerState extends State<PictureViewer> {
  late String imageUrl;
  bool orangeBtnShow = true;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  Future<void> originalBtnClick() async {
    LogUtils.d("btn click");
    String originalImageUrl = getOriginalImage(widget.imageUrl);
    try {
      var file = await DefaultCacheManager().getSingleFile(originalImageUrl);
      orangeBtnShow = false;
    } catch (e) {
      LogUtils.d("load original image");
    }
    setState(() {
      imageUrl = originalImageUrl;
    });
  }

  String getOriginalImage(String url){
    return url.replaceAll("_z", "");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Stack(
      children: [
        PhotoView.customChild(
          wantKeepAlive: true,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          customSize: MediaQuery.of(context).size,
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
                    textStyle: themeTextStyle(color: ThemeColor.red),
                    onTap: () async {
                      await saveNetworkImg(
                          imgUrl: imageUrl,
                          progressCallback: (current, total) {
                            EasyLoading.showProgress(
                                current / (widget.imageSize ?? total));
                          });
                      EasyLoading.dismiss();
                    }),
                SheetButtonModel(
                    title: S.current.save_original_image,
                    textStyle: themeTextStyle(color: ThemeColor.black),
                    onTap: () async {
                      EasyLoading.show();
                      await saveNetworkImg(
                          imgUrl: imageUrl.replaceAll("_z", ""),
                          progressCallback: (current, total) {});
                      EasyLoading.dismiss();
                    }),
                SheetButtonModel(
                    title: S.current.cancel,
                    textStyle: themeTextStyle(color: ThemeColor.blackLight),
                    bottomLine: false)
              ]);
            },
            child: CachedNetworkImage(
                imageUrl: imageUrl,
                httpHeaders: const {"Connection": "keep-alive"},
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                fadeInDuration: const Duration(milliseconds: 100),
                fadeOutDuration: const Duration(milliseconds: 100),
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  print('downloadProgress:${downloadProgress.progress}');
                  double progress =
                      downloadProgress.downloaded / (widget.imageSize ?? 1);
                  return Center(
                    child: CircularProgressIndicator(value: progress),
                  );
                },
                errorWidget: (context, object, _) {
                  return const Text('这张保密');
                }),
          ),
        ),
        if (orangeBtnShow)
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: MaterialButton(
                color: ThemeColor.blackLight,
                onPressed: originalBtnClick,
                child: Text(
                  S.current.original_image,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          )
      ],
    );
  }
}
