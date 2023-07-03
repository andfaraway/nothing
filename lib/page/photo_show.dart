//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-02 15:42:01
//
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/server_image_model.dart';
import 'package:nothing/widgets/picture_viewer.dart';

class PhotoShow extends StatefulWidget {
  final dynamic arguments;

  const PhotoShow({Key? key, this.arguments}) : super(key: key);

  @override
  State<PhotoShow> createState() => _PhotoShowState();
}

class _PhotoShowState extends State<PhotoShow> {
  final ValueNotifier<bool> photoEdit = ValueNotifier(false);

  ServerImageModel currentModel = ServerImageModel();

  final ValueNotifier<String> imageName = ValueNotifier('');

  bool _loadError = false;

  /// 长按3秒弹出选择目录
  int _lastWantToPop = 0;

  final List<ServerImageModel> _data = [];

  int _initIndex = 3;

  late String _catalog;

  @override
  void initState() {
    super.initState();

    _catalog = widget.arguments ?? 'deskTopImage';
    getImages(_catalog);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (detail) {
        _lastWantToPop = DateTime.now().millisecondsSinceEpoch;
      },
      onLongPressEnd: (detail) {
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastWantToPop > 3000) {
          changeCatalog();
        }
      },
      child: Scaffold(
        body: _data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Swiper(
                    onIndexChanged: (index) {
                      currentModel = _data[index];
                      HiveBoxes.put(HiveKey.photoShowIndex, index);
                    },
                    index: _initIndex,
                    itemHeight: 200,
                    layout: SwiperLayout.DEFAULT,
                    scrollDirection: Axis.vertical,
                    onTap: (index) {
                      currentModel = _data[index];
                      if (!_loadError) {
                        photoEdit.value = true;
                      }
                    },
                    itemBuilder: (context, i) {
                      ServerImageModel model = _data[i];
                      return Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: model.imageUrl ?? '1',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            fadeInDuration: const Duration(milliseconds: 100),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            progressIndicatorBuilder: (context, url, downloadProgress) {
                              _loadError = false;
                              double progress = downloadProgress.downloaded / (model.size ?? 1);
                              return Center(
                                child: CircularProgressIndicator(value: progress),
                              );
                            },
                            errorWidget: (context, object, _) {
                              _loadError = true;
                              return const LoadErrorWidget();
                            },
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SafeArea(
                              child: Text(
                                model.name ?? '',
                                style: const TextStyle(color: AppColor.black),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: _data.length,
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

  Future<void> getImages(String? catalog) async {
    catalog ??= 'deskTop';
    AppResponse response = await API.getImages(catalog);
    if (response.isSuccess) {
      _data.clear();
      for (Map<String, dynamic> map in response.dataList) {
        ServerImageModel model = ServerImageModel.fromJson(map);
        model.imageUrl = '${model.prefix}${model.name}';
        if (model.imageUrl!.contains('.')) {
          _data.add(model);
        }
      }
      _data.sort((a, b) {
        return a.name!.compareTo(b.name!);
      });

      _initIndex = HiveBoxes.get(HiveKey.photoShowIndex, defaultValue: 0);
      setState(() {});
    }
  }

  void changeCatalog() {
    showEdit(
      context,
      title: '情书',
      text: _catalog,
      commitPressed: (value) {
        if (value != null || value != '') {
          if (_catalog.contains(value) || value.toString().contains(_catalog)) {
            HiveBoxes.put(HiveKey.photoShowIndex, 0);
          }
          if (value == '~') {
            value = '';
          }
          getImages(value);
        }
      },
      cancelPressed: () {},
    );
  }
}
