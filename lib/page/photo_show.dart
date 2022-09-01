//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-02 15:42:01
//
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:nothing/model/server_image_model.dart';
import 'package:nothing/public.dart';
import 'package:nothing/widgets/picture_viewer.dart';
import 'photo_show_vm.dart';

class PhotoShow extends BasePage<_PhotoShowState> {
  const PhotoShow({Key? key}) : super(key: key);

  @override
  _PhotoShowState createBaseState() => _PhotoShowState();
}

class _PhotoShowState extends BaseState<PhotoShowVM, PhotoShow> {
  @override
  PhotoShowVM createVM() => PhotoShowVM(context);

  final ValueNotifier<bool> photoEdit = ValueNotifier(false);

  ServerImageModel currentModel = ServerImageModel();

  @override
  Widget createContentWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: vm.data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox(
                  child: Swiper(
                    onIndexChanged: (index) async{
                      await LocalDataUtils.setInt('initIndex', index);
                    },
                    index: vm.initIndex,
                    itemHeight: 200,
                    layout: SwiperLayout.DEFAULT,
                    scrollDirection: Axis.vertical,
                    onTap: (index) {
                      currentModel = vm.data[index];
                      photoEdit.value = true;
                    },
                    itemBuilder: (context, i) {
                      ServerImageModel model = vm.data[i];
                      return CachedNetworkImage(
                        imageUrl: model.imageUrl ?? '',
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          double progress =
                              downloadProgress.downloaded / (model.size ?? 1);
                          return Center(
                            child: CircularProgressIndicator(value: progress),
                          );
                        },
                        errorWidget: (context, object, _) {
                          return const Text('这张保密');
                        },
                      );
                    },
                    itemCount: vm.data.length,
                  ),
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
                    })
              ],
            ),
    );
  }
}
