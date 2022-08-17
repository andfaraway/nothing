import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nothing/public.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/photo_save.dart';

class PictureViewer extends StatelessWidget {
  final String imageUrl;
  final int? imageSize;
  final GestureTapCallback? onTap;

  const PictureViewer(
      {Key? key, required this.imageUrl, this.imageSize, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView.customChild(
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
        onTap: onTap,
        onLongPress: () {
          showSheet(context, [
            SheetButtonModel(
                title: S.current.save_to_album,
                textStyle: themeTextStyle(color: ThemeColor.red),
                onTap: () async {
                  await saveNetworkImg(
                      imgUrl: imageUrl,
                      progressCallback: (current, total) {
                        if (total == -1) {}
                        EasyLoading.showProgress(
                            current / (imageSize ?? total));
                      });
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
              double progress = downloadProgress.downloaded / (imageSize ?? 1);
              return Center(
                child: CircularProgressIndicator(value: progress),
              );
            },
            errorWidget: (context, object, _) {
              return const Text('这张保密');
            }),
      ),
    );
  }
}
