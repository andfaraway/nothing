//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-02 15:42:01
//
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/server_image_model.dart';
import 'package:nothing/widgets/picture_viewer.dart';

import 'photo_show_vm.dart';

class PhotoShow extends BasePage<_PhotoShowState> {
  final dynamic arguments;

  const PhotoShow({Key? key, this.arguments}) : super(key: key);

  @override
  _PhotoShowState createBaseState() => _PhotoShowState();
}

class _PhotoShowState extends BaseState<PhotoShowVM, PhotoShow> {
  @override
  PhotoShowVM createVM() => PhotoShowVM(context);

  final ValueNotifier<bool> photoEdit = ValueNotifier(false);

  ServerImageModel currentModel = ServerImageModel();

  final ValueNotifier<String> imageName = ValueNotifier('');

  bool loadError = false;

  /// 长按3秒弹出选择目录
  int _lastWantToPop = 0;

  @override
  Widget createContentWidget() {
    return GestureDetector(
      onLongPressStart: (detail) {
        _lastWantToPop = DateTime.now().millisecondsSinceEpoch;
      },
      onLongPressEnd: (detail) {
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastWantToPop > 3000) {
          vm.changeCatalog();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: vm.data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Swiper(
                    onIndexChanged: (index) {
                      currentModel = vm.data[index];
                      HiveBoxes.put(HiveKey.photoShowIndex, index);
                    },
                    index: vm.initIndex,
                    itemHeight: 200,
                    layout: SwiperLayout.DEFAULT,
                    scrollDirection: Axis.vertical,
                    onTap: (index) {
                      currentModel = vm.data[index];
                      if (!loadError) {
                        photoEdit.value = true;
                      }
                    },
                    itemBuilder: (context, i) {
                      ServerImageModel model = vm.data[i];
                      return Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: model.imageUrl ?? '1',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            fadeInDuration: const Duration(milliseconds: 100),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
                              loadError = false;
                              double progress = downloadProgress.downloaded /
                                  (model.size ?? 1);
                              return Center(
                                child:
                                    CircularProgressIndicator(value: progress),
                              );
                            },
                            errorWidget: (context, object, _) {
                              loadError = true;
                              return const LoadErrorWidget();
                            },
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SafeArea(
                              child: Text(
                                model.name ?? '',
                                style: const TextStyle(color: ThemeColor.black),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: vm.data.length,
                  ),
                  ValueListenableBuilder(
                      valueListenable: photoEdit,
                      builder: (context, bool edit, child) {
                        return edit
                            ? PictureViewer(
                                imageUrl: currentModel.imageUrl ?? '',
                                imageSize: currentModel.size,
                                imageName: currentModel.name,
                                onTap: () {
                                  photoEdit.value = false;
                                },
                              )
                            : const SizedBox.shrink();
                      }),
                ],
              ),
      ),
    );
  }
}
